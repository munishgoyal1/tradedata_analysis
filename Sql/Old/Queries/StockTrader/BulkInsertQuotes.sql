BULK INSERT dbo.st_derivatives_quote_historical
   FROM '\\mgoyal-home\stockdata\NIFTY xy_F1.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO