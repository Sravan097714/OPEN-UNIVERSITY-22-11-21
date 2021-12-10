codeunit 50021 "Process Full Program Fee"
{

    TableNo = "Full Prog. Fee From OU Protal";
    trigger OnRun();
    var
        Selection: Integer;
    begin
        FullPgmFee := Rec;

        if ValidatedFullPgmFee(FullPgmFee) then
            CreateSalesInvoice(FullPgmFee);

        Rec := FullPgmFee;
    end;

    procedure ValidatedFullPgmFee(var FullPgmFeePar: Record "Full Prog. Fee From OU Protal"): Boolean
    var
        Customer: Record Customer;
        Item: Record Item;
        FullPgmFeePar3: Record "ReRegistration Fee OU Portal";
        GenLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        Customer.get(FullPgmFeePar."Learner ID");

        GenLedgSetup.Get();
        if FullPgmFeePar."Prog. Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 1 Code", FullPgmFeePar."Prog. Code");

        if FullPgmFeePar.Intake <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 2 Code", FullPgmFeePar.Intake);

        exit(true);
    end;

    procedure CreateSalesInvoice(var FullPgmFeePar: Record "Full Prog. Fee From OU Protal")
    var
        ltextPTN: Text[25];
        gintCounter: Integer;
        grecCustPostingGrp: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesHeader: Record "Sales Header";
    begin
        FullPgmFeePar.TestField(Validated, true);

        SalesReceivableSetup.Get;

        SalesHeader.Init;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."Posted Inv Nos. for OU Portal", Today, TRUE);
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.validate("Sell-to Customer No.", FullPgmFeePar."Learner ID");
        SalesHeader.Validate("Posting Date", FullPgmFeePar."Payment Date");
        SalesHeader.Insert(true);
        SalesHeader.Validate("Shortcut Dimension 1 Code", FullPgmFeePar."Prog. Code");
        SalesHeader.Validate("Shortcut Dimension 2 Code", FullPgmFeePar.Intake);
        SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Full Pgm. Fee");
        SalesHeader."First Name" := FullPgmFeePar."First Name";
        SalesHeader."Last Name" := FullPgmFeePar."Last Name";
        SalesHeader."Maiden Name" := FullPgmFeePar."Maiden Name";
        SalesHeader.RDAP := FullPgmFeePar.RDAP;
        //SalesHeader."Payment Semester" := FullPgmFeePar."Payment Semester";
        SalesHeader."From OU Portal" := true;

        if (FullPgmFeePar.Currency <> '') and (FullPgmFeePar.Currency <> 'Rs') then
            SalesHeader."Currency Code" := 'USD';

        SalesHeader."Payment Amount" := FullPgmFeePar."Payment Amount";
        SalesHeader."Portal Payment Mode" := FullPgmFeePar."Payment Mode";
        SalesHeader."MyT Money Ref" := FullPgmFeePar."MyT Money Ref";
        SalesHeader."Payment Date" := FullPgmFeePar."Payment Date";

        SalesHeader.Modify();

        CreateSalesInvoiceLine(SalesHeader."No.", FullPgmFeePar);

        FullPgmFeePar."NAV Doc No." := SalesHeader."No.";
        FullPgmFeePar.Modify();
    end;

    procedure CreateSalesInvoiceLine(pcodeDocNo: Code[20]; FullPgmFeeLPar: Record "Full Prog. Fee From OU Protal")
    var
        grecDimValue: Record "Dimension Value";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("G/L for Full Pgm Fee");
        grecSalesLine.Init;
        grecSalesLine."Document No." := pcodeDocNo;
        grecSalesLine.Validate("Document Type", grecSalesLine."Document Type"::Invoice);
        grecSalesLine.Validate(Type, grecSalesLine.Type::"G/L Account");
        grecSalesLine.Validate("No.", SalesReceivableSetup."G/L for Full Pgm Fee");

        grecSalesLine.Validate("Unit Price", FullPgmFeeLPar."Payment Amount");

        grecSalesLine.Validate(Quantity, 1);

        grecSalesLine2.reset;
        grecSalesLine2.SetRange("Document No.", pcodeDocNo);
        if not grecSalesLine2.FindLast then
            grecSalesLine."Line No." := 10000
        else
            grecSalesLine."Line No." := grecSalesLine2."Line No." + 10000;

        grecSalesLine.Insert(true);
    end;

    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        FullPgmFee: Record "Full Prog. Fee From OU Protal";
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
}