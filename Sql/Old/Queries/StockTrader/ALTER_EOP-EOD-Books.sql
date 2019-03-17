ALTER TABLE st_trading_eop_statsbook 
ADD 
brokerage decimal(12, 2) not null default 0, 
r1 varchar(100)		 null,
r2 varchar(100)		 null
GO


ALTER TABLE st_trading_eod_statsbook 
ADD 
actual_roi_percentage decimal(12, 2) not null default 0,
actual_profit decimal(12, 2) not null default 0

GO


ALTER TABLE st_trading_eod_statsbook 
ADD 
brokerage decimal(12, 2) not null default 0, 
min_price decimal(12, 2) not null default 0,
max_price decimal(12, 2) not null default 0,
r1 varchar(100)		 null,
r2 varchar(100)		 null
GO

ALTER TABLE st_trading_eod_statsbook 
ADD 
quantity int not null default 1
GO
ALTER TABLE st_trading_eop_statsbook 
ADD 
quantity int not null default 1
GO