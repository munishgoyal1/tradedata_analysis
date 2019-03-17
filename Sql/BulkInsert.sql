    --BULK INSERT MULTIPLE FILES From a Folder 

    --a table to loop thru filenames drop table ALLFILENAMES
	--DROP table ALLFILENAMES
	--GO

    CREATE TABLE ALLFILENAMES(WHICHPATH VARCHAR(255),WHICHFILE varchar(255))

    --some variables
    declare @filename varchar(255),
            @path     varchar(255),
            @sql      varchar(8000),
            @cmd      varchar(1000)


    --get the list of files to process:
    SET @path = 'C:\Bhavcopies\EQUITIES\'
    SET @cmd = 'dir ' + @path + '*.csv /b'
    INSERT INTO  ALLFILENAMES(WHICHFILE)
    EXEC Master..xp_cmdShell @cmd
    UPDATE ALLFILENAMES SET WHICHPATH = @path where WHICHPATH is null


    --cursor loop
    declare c1 cursor for SELECT WHICHPATH,WHICHFILE FROM ALLFILENAMES where WHICHFILE like '%.csv%'
    open c1
    fetch next from c1 into @path,@filename
    While @@fetch_status <> -1
      begin
      --bulk insert won't take a variable name, so make a sql and execute it instead:
       set @sql = 'BULK INSERT nse_eod_eq FROM ''' + @path + @filename + ''' '
           + '     WITH ( 
                   FIELDTERMINATOR = '','', 
                   ROWTERMINATOR = ''0x0a'', 
                   FIRSTROW = 2,
				   ERRORFILE = ''C:\bulk-insert'',
				   KEEPNULLS
                ) '
    print @sql
    exec (@sql)

      fetch next from c1 into @path,@filename
      end
    close c1
    deallocate c1

	GO

	DROP table ALLFILENAMES
	GO


	-- single bulk inser experiment
	--BULK INSERT nse_eod_eq FROM 'C:\Bhavcopies\EQUITIES\cm20SEP2010bhav.csv'
 --          WITH ( 
 --                  FIELDTERMINATOR = ',', 
 --                  ROWTERMINATOR = '0x0a', 
 --                  FIRSTROW = 2 ,
	--			   KEEPNULLS
 --               ) 