codeunit 50016 "Process Module Fee"
{

    TableNo = "Module Fee From OU Portal";
    trigger OnRun();
    begin
        ModuleFeeGRec := Rec;
        ModuleFeeGRec.Error := '';
        Window.Open('Processing Line ##1###############');
        if ValidatedModuleFee(ModuleFeeGRec) then
            CreateSalesInvoice(ModuleFeeGRec);
        Window.Close();
        Rec := ModuleFeeGRec;
    end;

    local procedure ValidatedModuleFee(var ModuleFeePar: Record "Module Fee From OU Portal"): Boolean
    var
        Customer: Record Customer;
        Customer2: Record Customer;
        Item: Record Item;
        GenLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        Window.Update(1, ModuleFeePar."Line No.");
        SalesReceivableSetup.Get();
        if not Customer.get(ModuleFeePar."Learner ID") then begin
            Customer2.Init();
            Customer2."No." := ModuleFeePar."Learner ID";
            Customer2.Name := ModuleFeePar."First Name" + ' ' + ModuleFeePar."Last Name";
            Customer2."First Name" := ModuleFeePar."First Name";
            Customer2."Last Name" := ModuleFeePar."Last Name";
            Customer2."Maiden Name" := ModuleFeePar."Maiden Name";
            Customer2.Address := ModuleFeePar.Address;
            Customer2."Phone No." := ModuleFeePar."Phone No.";
            Customer2."Mobile Phone No." := ModuleFeePar."Mobile No.";
            Customer2."Country/Region Code" := ModuleFeePar.Country;
            Customer2."VAT Bus. Posting Group" := SalesReceivableSetup."VAT Bus. Posting Group";
            Customer2."Gen. Bus. Posting Group" := SalesReceivableSetup."Gen. Bus. Posting Group";
            Customer2."Customer Posting Group" := SalesReceivableSetup."Customer Posting Group";
            //Customer2."Customer Category" := Customer2."Customer Category";
            Customer2.Insert();
        end;
        //ModuleFeePar.Error := 'Student Number does not exist.';

        if ModuleFeePar."No. 1" <> '' then
            Item.Get(ModuleFeePar."No. 1");

        if ModuleFeePar."No. 2" <> '' then
            Item.Get(ModuleFeePar."No. 2");

        if ModuleFeePar."No. 3" <> '' then
            Item.Get(ModuleFeePar."No. 3");

        if ModuleFeePar."No. 4" <> '' then
            Item.Get(ModuleFeePar."No. 4");

        if ModuleFeePar."No. 5" <> '' then
            Item.Get(ModuleFeePar."No. 5");

        if ModuleFeePar."No. 6" <> '' then
            Item.Get(ModuleFeePar."No. 6");


        GenLedgSetup.Get();

        if ModuleFeePar."Shortcut Dimension 1 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 1 Code", ModuleFeePar."Shortcut Dimension 1 Code");

        if ModuleFeePar."Shortcut Dimension 2 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 2 Code", ModuleFeePar."Shortcut Dimension 2 Code");

        if (ModuleFeePar."No. 1" = '') AND
            (ModuleFeePar."No. 2" = '') AND
            (ModuleFeePar."No. 3" = '') AND
            (ModuleFeePar."No. 4" = '') AND
            (ModuleFeePar."No. 5" = '') AND
            (ModuleFeePar."No. 6" = '')
        then
            Error('There are no module code on this line.');


        exit(true);
    end;

    local procedure CreateSalesInvoice(var ModuleFeePar: Record "Module Fee From OU Portal")
    var
        SalesHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustPostingGrp: Record "Customer Posting Group";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("No. Series for OU Portal");

        if ModuleFeePar.Error <> '' then
            exit;

        Window.Update(1, ModuleFeePar."Line No.");
        SalesHeader.Init;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."No. Series for OU Portal", Today, TRUE);
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.validate("Sell-to Customer No.", ModuleFeePar."Learner ID");
        SalesHeader.Validate("Posting Date", ModuleFeePar."Posting Date");
        SalesHeader.Insert(true);

        SalesHeader.Validate("Shortcut Dimension 1 Code", ModuleFeePar."Shortcut Dimension 1 Code");
        SalesHeader.Validate("Shortcut Dimension 2 Code", ModuleFeePar."Shortcut Dimension 2 Code");
        SalesHeader."First Name" := ModuleFeePar."First Name";
        SalesHeader."Last Name" := ModuleFeePar."Last Name";
        SalesHeader."Maiden Name" := ModuleFeePar."Maiden Name";
        SalesHeader.RDAP := ModuleFeePar.RDAP;
        SalesHeader.RDBL := ModuleFeePar.RDBL;
        SalesHeader.NIC := ModuleFeePar.NIC;
        SalesHeader."Login Email" := ModuleFeePar."Login Email";
        SalesHeader."Contact Email" := ModuleFeePar."Contact Email";
        SalesHeader."From OU Portal" := true;

        SalesHeader."Gov Grant" := ModuleFeePar."Gov Grant";
        SalesHeader.Instalment := ModuleFeePar.Instalment;
        SalesHeader."Payment Amount" := ModuleFeePar."Payment Amount";
        SalesHeader."Portal Payment Mode" := ModuleFeePar."Portal Payment Mode";
        SalesHeader."MyT Money Ref" := ModuleFeePar."MyT Money Ref";
        SalesHeader."Payment Date" := ModuleFeePar."Payment Date";

        if (ModuleFeePar.Currency <> '') and (ModuleFeePar.Currency <> 'Rs') then
            SalesHeader."Currency Code" := 'USD';

        if ModuleFeePar.Instalment then
            SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Mod. Fee Ins")
        else
            SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Mod. Fee Without Ins");

        SalesHeader.Modify();

        if ModuleFeePar."No. 1" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 1", ModuleFeePar."Common Module Code 1", ModuleFeePar."Module Description 1", ModuleFeePar."Module Amount 1", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        if ModuleFeePar."No. 2" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 2", ModuleFeePar."Common Module Code 2", ModuleFeePar."Module Description 2", ModuleFeePar."Module Amount 2", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        if ModuleFeePar."No. 3" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 3", ModuleFeePar."Common Module Code 3", ModuleFeePar."Module Description 3", ModuleFeePar."Module Amount 3", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        if ModuleFeePar."No. 4" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 4", ModuleFeePar."Common Module Code 4", ModuleFeePar."Module Description 4", ModuleFeePar."Module Amount 4", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        if ModuleFeePar."No. 5" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 5", ModuleFeePar."Common Module Code 5", ModuleFeePar."Module Description 5", ModuleFeePar."Module Amount 5", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        if ModuleFeePar."No. 6" <> '' then
            CreateSalesInvoiceLine(SalesHeader."No.", ModuleFeePar."No. 6", ModuleFeePar."Common Module Code 6", ModuleFeePar."Module Description 6", ModuleFeePar."Module Amount 6", ModuleFeePar."Shortcut Dimension 1 Code", ModuleFeePar.Instalment, ModuleFeePar."Module 1 Fee Ins");

        ModuleFeePar."NAV Doc No." := SalesHeader."No.";
        ModuleFeePar.Modify();

    end;

    procedure CreateSalesInvoiceLine(pcodeDocNo: Code[20]; pcodeModuleNo: Code[20]; pcodeCommonModuleCode: Code[20]; ptextDescription: Text[250]; pdecAmount: Decimal; DimValue1: Code[20]; pboolInstalment: Boolean; pdecInstalmentAmt: Decimal)
    var
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
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
    end;

    var
        ModuleFeeGRec: Record "Module Fee From OU Portal";
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        Window: Dialog;
}