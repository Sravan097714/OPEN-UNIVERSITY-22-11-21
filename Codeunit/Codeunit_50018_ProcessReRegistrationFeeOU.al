codeunit 50018 "Process ReRegistration Fee"
{

    TableNo = "ReRegistration Fee OU Portal";
    trigger OnRun();
    var
        Selection: Integer;
    begin
        ReRegistrationFee := Rec;
        if GuiAllowed then
            Window.Open('Processing Line ##1###############');

        if ValidateReRegistrationFee(ReRegistrationFee) then
            CreateSalesInvoice(ReRegistrationFee);

        if GuiAllowed then
            Window.Close();
        Rec := ReRegistrationFee;
    end;

    local procedure ValidateReRegistrationFee(var ReRegistrationFeePar: Record "ReRegistration Fee OU Portal"): Boolean
    var
        Customer: Record Customer;
        Customer2: Record Customer;
        Item: Record Item;
        GenLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        SalesHeaderLRec: Record "Sales Header";
    begin
        if GuiAllowed then
            Window.Update(1, ReRegistrationFeePar."Line No.");

        SalesReceivableSetup.Get();
        if (not Customer.get(ReRegistrationFeePar."Student ID")) and (ReRegistrationFeePar."Student ID" <> '') then begin
            Customer2.Init();
            Customer2."No." := ReRegistrationFeePar."Student ID";
            Customer2.Name := ReRegistrationFeePar."First Name" + ' ' + ReRegistrationFeePar."Last Name";
            Customer2."First Name" := ReRegistrationFeePar."First Name";
            Customer2."Last Name" := ReRegistrationFeePar."Last Name";
            Customer2."Maiden Name" := ReRegistrationFeePar."Maiden Name";
            /*
            Customer2.Address := ReRegistrationFeePar.Address;
            Customer2."Phone No." := ReRegistrationFeePar."Phone No.";
            Customer2."Mobile Phone No." := ReRegistrationFeePar."Mobile No.";
            Customer2."Country/Region Code" := ReRegistrationFeePar.Country;
            */
            Customer2."VAT Bus. Posting Group" := SalesReceivableSetup."VAT Bus. Posting Group";
            Customer2."Gen. Bus. Posting Group" := SalesReceivableSetup."Gen. Bus. Posting Group";
            Customer2."Customer Posting Group" := SalesReceivableSetup."Customer Posting Group";
            //Customer2."Customer Category" := Customer2."Customer Category";
            Customer2.Insert();
            Commit();
        end;

        ReRegistrationFeePar3.reset;
        ReRegistrationFeePar3.SetRange(PTN, ReRegistrationFeePar.PTN);
        ReRegistrationFeePar3.SetFilter("Module ID", '<>%1', '');
        if ReRegistrationFeePar3.FindSet() then
            repeat
                Item.Get(ReRegistrationFeePar3."Module ID");
            until ReRegistrationFeePar3.Next() = 0
        else
            Error('There are no module code on one line.');

        SalesHeaderLRec.Reset();
        SalesHeaderLRec.SetRange(PTN, ReRegistrationFeePar.PTN);
        if SalesHeaderLRec.FindFirst() then
            Error('Sales Invoice already exsits for same PTN No. The Sales Invoice No. is %1', SalesHeaderLRec."No.");

        GenLedgSetup.Get();

        if ReRegistrationFeePar."Shortcut Dimension 1 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 1 Code", ReRegistrationFeePar."Shortcut Dimension 1 Code");

        if ReRegistrationFeePar."Shortcut Dimension 2 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 2 Code", ReRegistrationFeePar."Shortcut Dimension 2 Code");

        exit(true);
    end;

    local procedure CreateSalesInvoice(var ReRegistrationFeePar: Record "ReRegistration Fee OU Portal")
    var
        ltextPTN: Text[25];
        gintCounter: Integer;
        grecCustPostingGrp: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesHeader: Record "Sales Header";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("No. Series for OU Portal");

        if ReRegistrationFeePar.Error <> '' then
            exit;
        if GuiAllowed then
            Window.Update(1, ReRegistrationFeePar."Line No.");

        SalesHeader.Init;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."No. Series for OU Portal", Today, TRUE);
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.validate("Sell-to Customer No.", ReRegistrationFeePar."Student ID");
        SalesHeader.Validate("Posting Date", ReRegistrationFeePar."Date Processed");
        SalesHeader.Insert(true);

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

        ReRegistrationFeePar3.reset;
        ReRegistrationFeePar3.SetRange(PTN, ReRegistrationFeePar.PTN);
        ReRegistrationFeePar3.SetFilter("Module ID", '<>%1', '');
        if ReRegistrationFeePar3.FindSet() then
            repeat
                CreateSalesInvoiceLine(SalesHeader."No.", ReRegistrationFeePar3."Module ID", ReRegistrationFeePar3."Common Module Code", ReRegistrationFeePar3."Module Description", ReRegistrationFeePar3."Module Amount", ReRegistrationFeePar3."Shortcut Dimension 1 Code", ReRegistrationFeePar3.Instalment, ReRegistrationFeePar3."Module Fee Ins", ReRegistrationFeePar3."Penalty Fee", ReRegistrationFeePar3."No.");
                ReRegistrationFeePar3."NAV Doc No." := SalesHeader."No.";
                ReRegistrationFeePar3.Modify();
            until ReRegistrationFeePar3.Next() = 0;

        ReRegistrationFeePar."NAV Doc No." := SalesHeader."No.";
        ReRegistrationFeePar.Modify();
    end;

    local procedure CreateSalesInvoiceLine(pcodeDocNo: Code[20]; pcodeModuleNo: Code[20]; pcodeCommonModuleCode: Code[20]; ptextDescription: Text[250]; pdecAmount: Decimal; DimValue1: Code[20]; pboolInstalment: Boolean; pdecInstalmentAmt: Decimal; pdecPenaltyFee: Decimal; PModuleID: code[20])
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
        grecSalesLine."Module Code" := PModuleID;

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
        ReRegistrationFeePar3: Record "ReRegistration Fee OU Portal";
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
        Window: Dialog;
}