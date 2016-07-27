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

    authorNamesFirstLast = { 'LastName': [],
                             'ForeName': [],
                             'Initials': []}
    paperCount = 0
    try:
        for event, elem in context:
            if elem.xpath('Author/LastName/text( )'):
                try:
                    authorNames, authorNamesFirstLast, paperCount = func(paperCount,
                                                                    authorNames,
                                                                    authorNamesFirstLast,
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
                except:
                    continue
            elif elem.xpath('Author/LastName/text( )') == []:
                continue
            else:
                continue
    except:
        pass
    del context
    
    return authorNames, authorNamesFirstLast, paperCount

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


def process_element(paperCount, authorNames, authorNamesFirstLast, elem):
    paperCount += 1
    authors_in_paper = range(len(elem.xpath( 'Author/LastName/text( )' )))
    authorNames = identify_authors_details(authorNames, elem, authors_in_paper)
    if (paperCount % 100000 == 0): print paperCount
    if len(authors_in_paper) == 1:
        authorNamesFirstLast = identify_authors_details(authorNamesFirstLast,
                                                        elem, [0])
    elif len(authors_in_paper) > 1:
        index = [0, -1]
        authorNamesFirstLast = identify_authors_details(authorNamesFirstLast,
                                                        elem, index)
    else:
        pass
    return authorNames, authorNamesFirstLast, paperCount

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


    indexHelp = 0
    duplicateIndexes = [[0,0] for x in xrange(iDetectDuplicate)]
    iDetectDuplicate = 0
    for iDuplicate in range(1,len(authorNames['LastName'])):
        if (indexHelp == 0) & (authorNames['LastName'][iDuplicate - 1] ==
                               authorNames['LastName'][iDuplicate]):
            try:
                duplicateIndexes[iDetectDuplicate][indexHelp] = iDuplicate - 1
                indexHelp = 1
            except:
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
                authorNames['ForeName'][indexToCheck]):
                duplicatesCount += 1

    return duplicatesCount

time_period = range(1998,2015)
counter = 0
results = [None] * len(time_period)
for i in time_period:
    year = str(i)
    print year
    try:
        # Insert path to read the xml file
        # The filename is assumed to be in the form:
        # "something_2015.xml", the code can be easily modified to 
        # serve different filenames
        path = "" + year + ".xml"
        context = etree.iterparse( path, tag='AuthorList' )
        authorNames, authorNamesFirstLast, paperCount = fast_iter(context, process_element)

        duplicatesCountAll = detect_duplicates(authorNames)
        distinctAuthorNamesAll = len(authorNames['LastName']) - duplicatesCountAll

        distinctArticles = paperCount
        results[counter] = {'year': year,
                            'papers': distinctArticles,
                            'authors': distinctAuthorNamesAll,
                            'authorsFirstLast': distinctAuthorNamesFirstLast}
        print results[counter]

        #Insert path to write the csv file
        temp_path = "" + year
        w = csv.writer(open(temp_path + ".csv", "w"))
        for m in results[counter].itervalues():
            w.writerow([m])
        print "Finished saving"
    except:
        print "Skipped " + year
        pass
