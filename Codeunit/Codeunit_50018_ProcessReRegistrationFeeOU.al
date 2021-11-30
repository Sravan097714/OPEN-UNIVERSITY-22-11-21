codeunit 50018 "Process ReRegistration Fee"
{

    TableNo = "ReRegistration Fee OU Portal";
    trigger OnRun();
    var
        Selection: Integer;
    begin
        ReRegistrationFee := Rec;
        Window.Open('Processing Line ##1###############');

        if ValidateReRegistrationFee(ReRegistrationFee) then
            CreateSalesInvoice(ReRegistrationFee);

        Window.Close();
        Rec := ReRegistrationFee;
    end;

    local procedure ValidateReRegistrationFee(var ReRegistrationFeePar: Record "ReRegistration Fee OU Portal"): Boolean
    var
        Customer: Record Customer;
        Item: Record Item;
        ReRegistrationFeePar3: Record "ReRegistration Fee OU Portal";
        GenLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin

        Customer.get(ReRegistrationFeePar."Student ID");

        if ReRegistrationFeePar."No." <> '' then
            Item.Get(ReRegistrationFeePar."No.");

        GenLedgSetup.Get();

        if ReRegistrationFeePar."Shortcut Dimension 1 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 1 Code", ReRegistrationFeePar."Shortcut Dimension 1 Code");

        if ReRegistrationFeePar."Shortcut Dimension 2 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 2 Code", ReRegistrationFeePar."Shortcut Dimension 2 Code");

        ReRegistrationFeePar3.reset;
        ReRegistrationFeePar3.SetRange(PTN, ReRegistrationFeePar.PTN);
        ReRegistrationFeePar3.SetFilter(Error, '<>%1', '');
        if ReRegistrationFeePar3.FindFirst() then begin
            ReRegistrationFeePar.Error := 'One or more line with the same PTN Number has an error.';
            ReRegistrationFeePar.Modify();
            exit(false);
        end;

        ReRegistrationFeePar3.reset;
        ReRegistrationFeePar3.SetRange(PTN, ReRegistrationFeePar.PTN);
        ReRegistrationFeePar3.SetFilter("No.", '<>%1', '');
        //ReRegistrationFeePar3.SetFilter(Error, '<>%1', '');
        if ReRegistrationFeePar3.Count = 0 then begin
            ReRegistrationFeePar.Error := 'There are no module code on this line.';
            ReRegistrationFeePar.Modify();
            exit(false);
        end;

        exit(true);
    end;

    local procedure CreateSalesInvoice(var ReRegistrationFeePar: Record "ReRegistration Fee OU Portal")
    var
        ltextPTN: Text[25];
        gintCounter: Integer;
        grecCustPostingGrp: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("No. Series for OU Portal");

        if ReRegistrationFeePar.Error <> '' then
            exit;

        SalesHeader2.Reset();
        SalesHeader2.SetRange(PTN, ReRegistrationFeePar.PTN);
        if not SalesHeader2.FindFirst() then begin
            SalesHeader.Init;
            SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."No. Series for OU Portal", Today, TRUE);
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
            SalesHeader.validate("Sell-to Customer No.", ReRegistrationFeePar."Student ID");
            SalesHeader.Validate("Posting Date", ReRegistrationFeePar."Date Processed");
            SalesHeader.Insert(true);
            if SalesReceivableSetup."Posted Inv Nos. for OU Portal" <> '' then
                SalesHeader.Validate("Posting No. Series", SalesReceivableSetup."Posted Inv Nos. for OU Portal");
            SalesHeader.Validate("Shortcut Dimension 1 Code", ReRegistrationFeePar."Shortcut Dimension 1 Code");
            SalesHeader.Validate("Shortcut Dimension 2 Code", ReRegistrationFeePar."Shortcut Dimension 2 Code");
            SalesHeader."First Name" := ReRegistrationFeePar."First Name";
            SalesHeader."Last Name" := ReRegistrationFeePar."Last Name";
            SalesHeader."Maiden Name" := ReRegistrationFeePar."Maiden Name";
            SalesHeader.RDAP := ReRegistrationFeePar.RDAP;
            SalesHeader.PTN := ReRegistrationFeePar.PTN;
            SalesHeader."Payment Semester" := ReRegistrationFeePar."Payment Semester";
            SalesHeader."From OU Portal" := true;

            if (ReRegistrationFeePar.Currency <> '') and (ReRegistrationFeePar.Currency <> 'Rs') then
                SalesHeader."Currency Code" := 'USD';

            SalesHeader."Gov Grant" := ReRegistrationFeePar."Gov Grant";
            SalesHeader.Instalment := ReRegistrationFeePar.Instalment;
            SalesHeader."Payment Amount" := ReRegistrationFeePar."Net Total";
            SalesHeader."Portal Payment Mode" := ReRegistrationFeePar."Payment Type";
            SalesHeader."MyT Money Ref" := ReRegistrationFeePar."MyT Money Ref";
            SalesHeader."MyT Merchant Trade No." := ReRegistrationFeePar."MyT Money Ref Staff";
            SalesHeader."Payment Date" := ReRegistrationFeePar."Date Paid On";

            if ReRegistrationFeePar.Instalment then
                SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Rereg. Fee Ins")
            else
                SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Rereg.Fee Without Ins");

            SalesHeader.Modify();
            ReRegistrationFeePar."NAV Doc No." := SalesHeader."No.";
        end;

        if ReRegistrationFeePar."No." <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ReRegistrationFeePar."No.", ReRegistrationFeePar."Common Module Code", ReRegistrationFeePar."Module Description", ReRegistrationFeePar."Module Amount", ReRegistrationFeePar."Shortcut Dimension 1 Code", ReRegistrationFeePar.Instalment, ReRegistrationFeePar."Module Fee Ins", ReRegistrationFeePar."Penalty Fee");

        if SalesHeader2."No." <> '' then
            ReRegistrationFeePar."NAV Doc No." := SalesHeader2."No.";
        ReRegistrationFeePar.Modify();
    end;

    local procedure CreateSalesInvoiceLine(pcodeDocNo: Code[20]; pcodeModuleNo: Code[20]; pcodeCommonModuleCode: Code[20]; ptextDescription: Text[250]; pdecAmount: Decimal; DimValue1: Code[20]; pboolInstalment: Boolean; pdecInstalmentAmt: Decimal; pdecPenaltyFee: Decimal)
    var
        grecDimValue: Record "Dimension Value";
    begin
        grecSalesLine.Init;
        grecSalesLine."Document No." := pcodeDocNo;
        grecSalesLine.Validate("Document Type", grecSalesLine."Document Type"::Invoice);
        grecSalesLine.Validate(Type, grecSalesLine.Type::Item);
        grecSalesLine.Validate("No.", pcodeModuleNo);
        grecSalesLine.Description := ptextDescription;

        if pboolInstalment then begin
            grecSalesLine.Validate("Unit Price", pdecInstalmentAmt);
            grecSalesLine.Instalment := pboolInstalment;
            grecSalesLine."Original Amount" := pdecAmount;
        end else
            grecSalesLine.Validate("Unit Price", pdecAmount);

        grecSalesLine.Validate(Quantity, 1);
        grecSalesLine."Common Module Code" := pcodeCommonModuleCode;

        grecSalesLine2.reset;
        grecSalesLine2.SetRange("Document No.", pcodeDocNo);
        if not grecSalesLine2.FindLast then
            grecSalesLine."Line No." := 10000
        else
            grecSalesLine."Line No." := grecSalesLine2."Line No." + 10000;


        /* grecDimValue.Reset();
        grecDimValue.SetRange(Code, DimValue1);
        if grecDimValue.FindFirst() then begin
            grecSalesLine.Validate("Gen. Prod. Posting Group", grecDimValue."Gen. Prod. Posting Group");
        end; */

        grecSalesLine.Insert(true);

        if pdecPenaltyFee > 0 then
            InsertPenaltyFee(pcodeDocNo, pdecPenaltyFee);
    end;


    local procedure InsertPenaltyFee(pcodeDocNo: Code[20]; pdecPenaltyFee: Decimal)
    begin
        SalesReceivableSetup.Get;
        SalesReceivableSetup.TestField("G/L for Penalty Fee");
        grecSalesLine.Init;
        grecSalesLine."Document No." := pcodeDocNo;
        grecSalesLine.Validate("Document Type", grecSalesLine."Document Type"::Invoice);
        grecSalesLine.Validate(Type, grecSalesLine.Type::"G/L Account");
        grecSalesLine.Validate("No.", SalesReceivableSetup."G/L for Penalty Fee");
        grecSalesLine.Validate("Unit Price", pdecPenaltyFee);
        grecSalesLine.Validate(Quantity, 1);

        grecSalesLine2.reset;
        grecSalesLine2.SetRange("Document No.", pcodeDocNo);
        if not grecSalesLine2.FindLast then
            grecSalesLine."Line No." := 10000
        else
            grecSalesLine."Line No." := grecSalesLine2."Line No." + 10000;

        /* grecDimValue.Reset();
        grecDimValue.SetRange(Code, DimValue1);
        if grecDimValue.FindFirst() then begin
            grecSalesLine.Validate("Gen. Prod. Posting Group", grecDimValue."Gen. Prod. Posting Group");
        end; */

        grecSalesLine.Insert(true);
    end;

    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        ReRegistrationFee: Record "ReRegistration Fee OU Portal";
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
        Window: Dialog;
}