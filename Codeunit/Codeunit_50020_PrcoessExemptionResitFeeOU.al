codeunit 50020 "Process ExemptionResit Fee"
{

    TableNo = "Exemption/Resit Fee OU Portal";
    trigger OnRun();
    begin
        ExemptResitFeeGRec := Rec;
        Window.Open('Processing Line ##1###############');
        if ValidatedModuleFee(ExemptResitFeeGRec) then begin
            if ExemptResitFeeGRec.Exemption then
                CreateSalesInvoiceExemption(ExemptResitFeeGRec)
            else
                CreateSalesInvoiceResit(ExemptResitFeeGRec);
        end;
        Window.Close();
        Rec := ExemptResitFeeGRec;
    end;

    local procedure ValidatedModuleFee(var ExemptResitFeePar: Record "Exemption/Resit Fee OU Portal"): Boolean
    var
        Customer: Record Customer;
        Customer2: Record Customer;
        Item: Record Item;
        GenLedgSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
    begin
        Window.Update(1, ExemptResitFeePar."Line No.");

        SalesReceivableSetup.Get();

        Customer.get(ExemptResitFeePar."Student ID");

        if ExemptResitFeePar."No." <> '' then
            Item.Get(ExemptResitFeePar."No.");

        GenLedgSetup.Get();

        if ExemptResitFeePar."Shortcut Dimension 1 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 1 Code", ExemptResitFeePar."Shortcut Dimension 1 Code");

        if ExemptResitFeePar."Shortcut Dimension 2 Code" <> '' then
            DimValue.Get(GenLedgSetup."Global Dimension 2 Code", ExemptResitFeePar."Shortcut Dimension 2 Code");

        exit(true);
    end;

    local procedure CreateSalesInvoiceExemption(var ExemptResitFeePar: Record "Exemption/Resit Fee OU Portal")
    var
        SalesHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustPostingGrp: Record "Customer Posting Group";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("No. Series for OU Portal");

        if ExemptResitFeePar.Error <> '' then
            exit;

        Window.Update(1, ExemptResitFeePar."Line No.");

        SalesHeader.Init;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."No. Series for OU Portal", Today, TRUE);
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.validate("Sell-to Customer No.", ExemptResitFeePar."Student ID");
        SalesHeader.Validate("Posting Date", ExemptResitFeePar."Date Processed");
        SalesHeader.Insert(true);

        SalesHeader.Validate("Shortcut Dimension 1 Code", ExemptResitFeePar."Shortcut Dimension 1 Code");
        SalesHeader.Validate("Shortcut Dimension 2 Code", ExemptResitFeePar."Shortcut Dimension 2 Code");
        SalesHeader."First Name" := ExemptResitFeePar."First Name";
        SalesHeader."Last Name" := ExemptResitFeePar."Last Name";
        SalesHeader."Maiden Name" := ExemptResitFeePar."Maiden Name";
        SalesHeader.RDAP := ExemptResitFeePar.RDAP;
        SalesHeader."Payment Semester" := ExemptResitFeePar."Payment Semester";
        SalesHeader."From OU Portal" := true;
        SalesHeader."Portal Payment Mode" := ExemptResitFeePar."Payment Mode";
        SalesHeader."Payment Date" := ExemptResitFeePar."Date Processed";
        SalesHeader.Remark := ExemptResitFeePar.Remarks;


        SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Exe. Fee");

        SalesHeader.Modify();

        if ExemptResitFeePar."No." <> '' then
            CreateSalesInvoiceLineExemption(SalesHeader."No.", ExemptResitFeePar."No.", ExemptResitFeePar."Common Module Code", ExemptResitFeePar."No." + ' - ' + ExemptResitFeePar."Module Description", ExemptResitFeePar."Module Credit", ExemptResitFeePar."Shortcut Dimension 1 Code");

        ExemptResitFeePar."NAV Doc No." := SalesHeader."No.";
        ExemptResitFeePar.Modify();
    end;

    local procedure CreateSalesInvoiceLineExemption(pcodeDocNo: Code[20]; pcodeModuleNo: Code[20]; pcodeCommonModuleCode: Code[20]; ptextDescription: Text[250]; pdecModuleCredit: Decimal; DimValue1: Code[20])
    var
        grecDimValue: Record "Dimension Value";
        grecSalesReceivableSetup2: Record "Sales & Receivables Setup";
    begin
        grecSalesReceivableSetup2.get;
        grecSalesLine.Init;
        grecSalesLine."Document No." := pcodeDocNo;
        grecSalesLine.Validate("Document Type", grecSalesLine."Document Type"::Invoice);
        grecSalesLine.Validate(Type, grecSalesLine.Type::"G/L Account");
        grecSalesLine.Validate("No.", grecSalesReceivableSetup2."G/L for Exemption Fee");
        grecSalesLine."Description 2" := ptextDescription;
        grecSalesLine.Validate("Unit Price", grecSalesReceivableSetup2."Exemption Amount");
        grecSalesLine.Validate(Quantity, 1);
        grecSalesLine."Common Module Code" := pcodeCommonModuleCode;
        //grecSalesLine.credit := pdecModuleCredit;

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

    local procedure CreateSalesInvoiceResit(var ExemptResitFeePar: Record "Exemption/Resit Fee OU Portal")
    var
        SalesHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustPostingGrp: Record "Customer Posting Group";
        SalesReceivableSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivableSetup.Get();
        SalesReceivableSetup.TestField("No. Series for OU Portal");

        if ExemptResitFeePar.Error <> '' then
            exit;
        SalesHeader.Init;
        SalesHeader."No." := NoSeriesMgt.GetNextNo(SalesReceivableSetup."No. Series for OU Portal", Today, TRUE);
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.validate("Sell-to Customer No.", ExemptResitFeePar."Student ID");
        SalesHeader.Validate("Posting Date", ExemptResitFeePar."Date Processed");
        SalesHeader.Insert(true);

        SalesHeader.Validate("Shortcut Dimension 1 Code", ExemptResitFeePar."Shortcut Dimension 1 Code");
        SalesHeader.Validate("Shortcut Dimension 2 Code", ExemptResitFeePar."Shortcut Dimension 2 Code");
        SalesHeader."First Name" := ExemptResitFeePar."First Name";
        SalesHeader."Last Name" := ExemptResitFeePar."Last Name";
        SalesHeader."Maiden Name" := ExemptResitFeePar."Maiden Name";
        SalesHeader.RDAP := ExemptResitFeePar.RDAP;
        SalesHeader."Payment Semester" := ExemptResitFeePar."Payment Semester";
        SalesHeader."From OU Portal" := true;
        //SalesHeader."Portal Payment Mode" := ExemptResitFeePar."Payment Mode";
        SalesHeader."Payment Date" := ExemptResitFeePar."Date Processed";
        SalesHeader.Remark := ExemptResitFeePar.Remarks;

        SalesHeader.Validate("Customer Posting Group", SalesReceivableSetup."Cust. PG Resit.Fee");

        SalesHeader.Modify();

        if ExemptResitFeePar."No." <> '' then
            CreateSalesInvoiceLineResit(SalesHeader."No.", ExemptResitFeePar."No.", ExemptResitFeePar."Common Module Code", ExemptResitFeePar."No." + ' - ' + ExemptResitFeePar."Module Description", ExemptResitFeePar."Module Credit", ExemptResitFeePar."Shortcut Dimension 1 Code");

        ExemptResitFeePar."NAV Doc No." := SalesHeader."No.";
        ExemptResitFeePar.Modify();

    end;


    local procedure CreateSalesInvoiceLineResit(pcodeDocNo: Code[20]; pcodeModuleNo: Code[20]; pcodeCommonModuleCode: Code[20]; ptextDescription: Text[250]; pdecModuleCredit: Decimal; DimValue1: Code[20])
    var
        grecDimValue: Record "Dimension Value";
        grecSalesReceivableSetup2: Record "Sales & Receivables Setup";
    begin
        grecSalesReceivableSetup2.get;
        grecSalesLine.Init;
        grecSalesLine."Document No." := pcodeDocNo;
        grecSalesLine.Validate("Document Type", grecSalesLine."Document Type"::Invoice);
        grecSalesLine.Validate(Type, grecSalesLine.Type::"G/L Account");
        grecSalesLine.Validate("No.", grecSalesReceivableSetup2."G/L for Exemption Fee");
        grecSalesLine."Description 2" := ptextDescription;
        grecSalesLine.Validate("Unit Price", grecSalesReceivableSetup2."Exemption Amount");
        grecSalesLine.Validate(Quantity, 1);
        grecSalesLine."Common Module Code" := pcodeCommonModuleCode;
        //grecSalesLine.credit := pdecModuleCredit;

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
        ExemptResitFeeGRec: Record "Exemption/Resit Fee OU Portal";
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
        Window: Dialog;
}