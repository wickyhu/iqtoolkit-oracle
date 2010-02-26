
For information about IQToolkit, check:
http://www.codeplex.com/IQToolkit
http://blogs.msdn.com/mattwar/pages/linq-links.aspx


IQToolkit.Data.OracleClient by WiCKY Hu
http://code.google.com/p/iqtoolkit-oracle/

Known Issues:

1. NorthwindExecutionTests

1) TestAllWithLocalCollection: Assert failure - expected: 9 actual: 3 
Reason: string compare is case censitive by default in Oracle

2) TestOrderByDistinct: Assert failure - expected: Portland actual: Paris
Reason: It's by designed.
refer to http://iqtoolkit.codeplex.com/WorkItem/View.aspx?WorkItemId=10863. 
mattwar: "This is a test meant to prove that the Distinct() operation actually undoes the ordering. This may not be what you want but it is as intended."


History:
Version 0.17.0:
First release
