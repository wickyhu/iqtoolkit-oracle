
For information about IQToolkit, check:
http://www.codeplex.com/IQToolkit
http://blogs.msdn.com/mattwar/pages/linq-links.aspx


IQToolkit.Data.OracleClient by WiCKY Hu
http://code.google.com/p/iqtoolkit-oracle/


Known Issues:

1. NorthwindExecutionTests
===========================
1) TestAllWithLocalCollection: Assert failure - expected: 9 actual: 3 
Reason: By default, string compare is case censitive in Oracle

2) TestOrderByDistinct: Assert failure - expected: Portland actual: Paris
Reason: It's by designed.
refer to http://iqtoolkit.codeplex.com/WorkItem/View.aspx?WorkItemId=10863. 
mattwar: "This is a test meant to prove that the Distinct() operation actually undoes the ordering. This may not be what you want but it is as intended."


2. NorthwindCUDTests
===========================
1) TestBatchDeleteCustomersWithDeleteCheckThatDoesNotSucceed: ORA-08179: concurrency check failed (error only occurs for ODP, it's ok for OracleClient)
Reason: Don't know, it happens in batch deleting NOT matched record. 
If batchsize set to 1, it's ok.
Really have no idea why delete 0 record will cause this error.
If you know, please kindly tell me.

  
History:

Version 0.17.1:
Support both OracleClient and ODP

Version 0.17.0:
First release
