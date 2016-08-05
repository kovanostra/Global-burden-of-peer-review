from lxml import etree
import pandas as pd
import csv

def fast_iter(context, func, *args, **kwargs):
    """
    http://lxml.de/parsing.html#modifying-the-tree
    Based on Liza Daly's fast_iter
    http://www.ibm.com/developerworks/xml/library/x-hiperfparse/
    See also http://effbot.org/zone/element-iterparse.htm
    """
    authorNames = { 'LastName': [],
                    'ForeName': [],
                    'Initials': []}
    paperCount = 0
    countErr = 0

    for event, elem in context:
        if elem.xpath('Author/LastName/text( )'):
            authorNames, paperCount = func(paperCount,
                                           authorNames,
                                           elem,
                                           *args,
                                           **kwargs)
            # It's safe to call clear() here because no descendants will be
            # accessed
            elem.clear()
            # Also eliminate now-empty references from the root node to elem
            for ancestor in elem.xpath('ancestor-or-self::*'):
                while ancestor.getprevious() is not None:
                    del ancestor.getparent()[0]
        elif elem.xpath('Author/LastName/text( )') == []:
            countErr += 1
            continue
        else:
            continue
    del context
    return authorNames, paperCount, countErr


def identify_authors_details(authorNames, elem, authors_in_paper):
    index = len(authors_in_paper)
    for i in range(index):
        authorNames['LastName'].append(elem.xpath(
                                       'Author/LastName/text( )' )[authors_in_paper[i]])
        try:
            authorNames['ForeName'].append(elem.xpath(
                                       'Author/ForeName/text( )' )[authors_in_paper[i]])
        except:
            authorNames['ForeName'].append(0)
        try:
            authorNames['Initials'].append(elem.xpath(
                                           'Author/Initials/text( )' )[authors_in_paper[i]])
        except:
            authorNames['Initials'].append(0)
    return authorNames


def process_element(paperCount, authorNames, elem):
    paperCount += 1
    authors_in_paper = range(len(elem.xpath( 'Author/LastName/text( )' )))
    authorNames = identify_authors_details(authorNames, elem, authors_in_paper)
    
    if (paperCount % 100000 == 0): 
        print str(paperCount) + ' papers parsed so far'

    return authorNames, paperCount

def detect_duplicates(authorNames):
    indexes = range(len(authorNames['LastName']))
    indexes.sort(key=authorNames['LastName'].__getitem__)
    authorNames['LastName'] = map(authorNames['LastName'].__getitem__, indexes)
    authorNames['ForeName'] = map(authorNames['ForeName'].__getitem__, indexes)
    authorNames['Initials'] = map(authorNames['Initials'].__getitem__, indexes)

    iDetectDuplicate = 0
    indexHelp = 0

    for iDuplicate in range(1,len(authorNames['LastName'])):
        if (indexHelp == 0) & (authorNames['LastName'][iDuplicate - 1] == 
                               authorNames['LastName'][iDuplicate]):
            indexHelp = 1
        elif (indexHelp == 1) & (authorNames['LastName'][iDuplicate - 1] !=
                                 authorNames['LastName'][iDuplicate]):
            indexHelp = 0
            iDetectDuplicate += 1

    duplicateIndexes = [[0,0] for x in xrange(iDetectDuplicate)]
    indexHelp = 0
    iDetectDuplicate = 0

    count = 0
    for iDuplicate in range(1,len(authorNames['LastName'])):
        if (indexHelp == 0) & (authorNames['LastName'][iDuplicate - 1] ==
                               authorNames['LastName'][iDuplicate]):
            try:
                duplicateIndexes[iDetectDuplicate][indexHelp] = iDuplicate - 1
                indexHelp = 1
            except:
                count += 1
                print str(count) + ' author(s) not analyzed\n'
                pass
        elif (indexHelp == 1) & (authorNames['LastName'][iDuplicate - 1] !=
                                 authorNames['LastName'][iDuplicate]):
            duplicateIndexes[iDetectDuplicate][indexHelp] = iDuplicate - 1
            indexHelp = 0
            iDetectDuplicate += 1


    duplicatesCount = 0
    for iDetectDuplicates in range(len(duplicateIndexes)):
        for iCheckNames in range(1,len(duplicateIndexes[iDetectDuplicates])):
            indexToCheck = duplicateIndexes[iDetectDuplicates][iCheckNames]
            if (authorNames['ForeName'][indexToCheck - 1] ==
                authorNames['ForeName'][indexToCheck]) \
                and \
               (authorNames['Initials'][indexToCheck - 1] ==
                authorNames['Initials'][indexToCheck]):
                duplicatesCount += 1

    return duplicatesCount

results = dict()

# Insert path to read the medline xml file
path = "C:\\Users\\Michail\\Desktop\\Papers\\3.The_global_burden_of_peer_review\\Data\\pubmed_" + str(1990) + ".xml"

context = etree.iterparse( path, tag='AuthorList' )
authorNames, paperCount, authorError = fast_iter(context, process_element)
print "\nFinished parsing. Analysis of distinct author names starting... \n"
duplicatesCount = detect_duplicates(authorNames)
distinctAuthorNames = len(authorNames['LastName']) - duplicatesCount

print 'Identified ' + str(len(authorNames['LastName'])) + ' author names in total'
print 'Identified ' + str(paperCount) + ' publications with ' + str(distinctAuthorNames) + ' distinct author names'
print 'There were ' + str(authorError) + ' cases where the last name of an author was missing'
