
@echo off
echo Cleaning ...

call deldir IQToolkit\obj
call deldir IQToolkit\bin\debug
call deldir IQToolkit\bin\release

call deldir IQToolkit.Data\obj
call deldir IQToolkit.Data\bin\debug
call deldir IQToolkit.Data\bin\release

call deldir IQToolkit.Data.OracleClient\obj
call deldir IQToolkit.Data.OracleClient\bin\debug
call delfile IQToolkit.Data.OracleClient\bin\release\*.pdb

call deldir IQToolkit.Data.SqlClient\obj
call deldir IQToolkit.Data.SqlClient\bin\debug
call delfile IQToolkit.Data.SqlClient\bin\release\*.pdb

call deldir Test\obj
call deldir Test\bin\debug
call delfile Test\bin\release\*.pdb

echo.
pause