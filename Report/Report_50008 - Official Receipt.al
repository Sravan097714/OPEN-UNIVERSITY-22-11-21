report 50008 "Official Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\OfficialReceipt.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Bank Account Ledger Entry" = rm;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Source Code" = FILTER('CASHRECJNL'));
            RequestFilterFields = "No.";
            column(CompInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(GLNo_; "G/L Register"."No.")
            {
            }
            column(CompInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompInfo_IncTitle; TRUE)
            {
            }
            column(CompanyInfoVATReg; CompanyInfo."VAT Registration No.")
            {

            }
            column(CompanyInfoBRN; CompanyInfo.BRN)
            {

            }
            column(CompanyInfoCity; CompanyInfo.City) { }
            column(CompanyInfoTel; CompanyInfo."Phone No.") { }
            column(CompanyInfoFax; CompanyInfo."Fax No.") { }
            dataitem(CopyLoop; Integer)
            {
                column(OutputNo_; OutputNo)
                {
                }
                column(CompArr1_; CompanyArr[1])
                {
                }
                column(CompArr2_; CompanyArr[2])
                {
                }
                column(CompArr3_; CompanyArr[3])
                {
                }
                column(CompArr4_; CompanyArr[4])
                {
                }
                column(CompArr5_; CompanyArr[5])
                {
                }
                column(CompArr6_; CompanyArr[6])
                {
                }
                column(CompArr7_; CompanyArr[7])
                {
                }
                column(CompArr8_; CompanyArr[8])
                {
                }
                column(CompArr9_; CompanyArr[9])
                {
                }
                column(CompArr10_; CompanyArr[10])
                {
                }
                column(Title2_; Title[2])
                {
                }

                dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                {
                    DataItemTableView = SORTING("Entry No.")
                                        WHERE("Source Code" = FILTER('CASHRECJNL'),
                                              Reversed = FILTER(false));
                    RequestFilterFields = "Document No.", "Document Type", "Source Code", "Posting Date";
                    column(DisplaySection_; DisplaySection)
                    {
                    }
                    column(ClientCodeCaption; ClientCodeCaption)//KTM11/02/22
                    {

                    }
                    column(ClientCode_; ClientCode)
                    {
                    }
                    column(VoidTrans_; VarVoid)
                    {
                    }
                    column(EntryNo_BLE; "Bank Account Ledger Entry"."Entry No.")
                    {
                    }
                    column(Title1_; Title[1])
                    {
                    }
                    column(DocumentNo_BLE; "Bank Account Ledger Entry"."Document No.")
                    {
                    }
                    column(CaptionArray1_; CaptionArray[1])
                    {
                    }
                    column(CaptionArray2_; CaptionArray[2])
                    {
                    }
                    column(CaptionArray3_; CaptionArray[3])
                    {
                    }
                    column(CaptionArray4_; CaptionArray[4])
                    {
                    }
                    column(CaptionArray5_; CaptionArray[5])
                    {
                    }
                    column(CustArray1_; CustArray[1])
                    {
                    }
                    column(CustArray2_; CustArray[2])
                    {
                    }
                    column(CustArray3_; CustArray[3])
                    {
                    }
                    column(CustArray4_; CustArray[4])
                    {
                    }
                    column(CustArray5_; CustArray[5])
                    {
                    }
                    column(CustArray6_; CustArray[6])
                    {
                    }
                    column(CustArray7_; CustArray[7])
                    {
                    }
                    column(PostingDate_BLE; FORMAT("Bank Account Ledger Entry"."Posting Date", 0, '<day,2>/<month,2>/<year4>'))
                    {
                    }
                    column(CurrencyCode_CLE; CustledgEntry."Currency Code")
                    {
                    }
                    column(Document_Date; FORMAT("Document Date", 0, '<day,2>/<month,2>/<year4>'))
                    { }
                    column(CurrencyCode_Lbl; CurrencyCode)
                    {
                    }
                    column(DotText_; DotText)
                    {
                    }
                    column(NumberText1_; NumberText[1])
                    {
                    }
                    column(NumberText2_; NumberText[2])
                    {
                    }
                    column(CustomerName; '')
                    {
                    }
                    column(ExtDocNo_BLE; "Bank Account Ledger Entry"."External Document No.")
                    {
                    }
                    column(AmtInFigures_; ABS(AmtInFigures))
                    {
                    }
                    column(ParticularsLBL_; ParticularsLbl)
                    {
                    }
                    column(ParticularsVal_; ParticularsVal)
                    {
                    }
                    column(PostingDate; FORMAT("Detailed Cust. Ledg. Entry"."Posting Date", 0, '<day,2>/<month,2>/<year4>'))
                    {
                    }
                    column(AppliedAmt; ABS("Detailed Cust. Ledg. Entry".Amount))
                    {
                    }
                    column(UnAppliedAmt; UnAppliedAmt)
                    {
                    }
                    column(TotalAmt; TotalAmt)
                    {
                    }
                    column(CurrencyCode_; CurCod)
                    {
                    }
                    column(Amount_BLE; ABS("Bank Account Ledger Entry".Amount))
                    {
                    }
                    column(PaymentMethodDesc_; PaymentMethodDesc)
                    {
                    }
                    column(Description_BLE; "Bank Account Ledger Entry".Description)
                    {
                    }
                    column(RemAmount_; RemAmount)
                    {
                    }
                    column(Received_From; "Bank Account Ledger Entry".Payee) { }
                    column(Payment_of; '') { }
                    // column(Amount; gdecAmount) { }//KTM11/02/22
                    column(Amount; ABS(gdecAmount)) { }//KTM11/02/22
                    column(Currency_Code; gtextCurrencyCode) { }
                    dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Transaction No." = FIELD("Transaction No.");
                        DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code")
                                            WHERE("Entry Type" = FILTER(Application | "Initial Entry"));
                        column(DocNo_CLE; CustLedgerEntry."Document No.")
                        {
                        }
                        column(DocType_; VarDocType)
                        {
                        }
                        column(DocumentDate_; FORMAT(CustLedgerEntry."Document Date", 0, '<day,2>/<month,2>/<year4>'))
                        {
                        }
                        column(DetAmount_; DetAmount)
                        {
                        }
                        column(Amount_DCLE; "Detailed Cust. Ledg. Entry".Amount * -1)
                        {
                        }
                        column(CurrencyCode_DCLE; ltextCurrencyCode)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin


                            IF ("Bank Account Ledger Entry"."Document Type" IN ["Bank Account Ledger Entry"."Document Type"::Payment,
                                "Bank Account Ledger Entry"."Document Type"::Refund]) AND
                            ("Bank Account Ledger Entry"."Bal. Account Type" <> "Bank Account Ledger Entry"."Bal. Account Type"::Customer) THEN
                                CurrReport.SKIP;

                            IF ("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No." IN ["G/L Register"."From Entry No."]) OR
                               ("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No." IN ["G/L Register"."To Entry No."]) THEN
                                CurrReport.SKIP;


                            IF CustLedgerEntry.GET("Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.") THEN BEGIN
                                CASE "Bank Account Ledger Entry"."Document Type" OF
                                    "Bank Account Ledger Entry"."Document Type"::Payment:
                                        VarDocType := FORMAT(CustLedgerEntry."Document Type");


                                    "Bank Account Ledger Entry"."Document Type"::Refund:
                                        VarDocType := 'Void';
                                END;
                            END;

                            if "Currency Code" = '' then
                                ltextCurrencyCode := 'MUR'
                            else
                                ltextCurrencyCode := "Currency Code";

                            IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Payment THEN
                                CurrReport.SKIP;
                        end;
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Transaction No." = FIELD("Transaction No.");
                        DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code")
                                            WHERE("Source Code" = FILTER('CASHRECJNL'));

                        trigger OnAfterGetRecord()
                        begin

                            IF ("Bank Account Ledger Entry"."Document Type" IN ["Bank Account Ledger Entry"."Document Type"::Payment,
                                "Bank Account Ledger Entry"."Document Type"::Refund]) AND
                            ("Bank Account Ledger Entry"."Bal. Account Type" <> "Bank Account Ledger Entry"."Bal. Account Type"::Customer) THEN
                                CurrReport.SKIP;

                            "Cust. Ledger Entry".CALCFIELDS("Cust. Ledger Entry"."Remaining Amount");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF "Bank Account Ledger Entry"."Bal. Account Type" = "Bank Account Ledger Entry"."Bal. Account Type"::"G/L Account" THEN
                            DisplaySection := true
                        ELSE
                            DisplaySection := TRUE;



                        CASE "Bank Account Ledger Entry"."Document Type" OF
                            "Bank Account Ledger Entry"."Document Type"::Refund:
                                BEGIN
                                    Title[1] := Text009;
                                    CaptionArray[1] := 'Payee';
                                    CaptionArray[2] := 'Void Date';
                                    CaptionArray[3] := 'Details of Void Receipt';
                                    CaptionArray[4] := 'VOID RECEIPT No';
                                    CaptionArray[5] := 'PROCESSED BY : ';
                                    VarVoid := TRUE;
                                END;
                            "Bank Account Ledger Entry"."Document Type"::Payment:
                                BEGIN
                                    Title[1] := Text001;
                                    CaptionArray[1] := 'Post Office';
                                    CaptionArray[2] := 'Receipt Date';
                                    CaptionArray[3] := 'We acknowledge receipt of the following';
                                    CaptionArray[4] := 'RECEIPT NO';
                                    CaptionArray[5] := 'RECEIVED BY : ';
                                    VarVoid := FALSE;
                                END;
                        END;

                        CLEAR(ClientCode);
                        CLEAR(CustArray);
                        CLEAR(RemAmount);



                        IF Customer.GET("Bal. Account No.") THEN BEGIN
                            CustArray[2] := Customer.Address;
                            CustArray[3] := Customer."Address 2";
                            CustArray[4] := Customer.City;
                            if Customer."VAT Registration No." <> '' then
                                CustArray[5] := 'VAT Registration No. : ' + Customer."VAT Registration No.";
                            CustArray[1] := Customer.Name;

                            IF Customer.BRN <> '' THEN BEGIN
                                CustArray[6] := 'BRN : ' + Customer.BRN;
                            END;

                            COMPRESSARRAY(CustArray);
                        END;


                        IF Vendor.GET("Bal. Account No.") THEN BEGIN
                            CustArray[2] := Vendor.Address;
                            CustArray[3] := Vendor."Address 2";
                            CustArray[4] := Vendor.City;
                            if Vendor."VAT Registration No." <> '' then
                                CustArray[5] := 'VAT Registration No. : ' + Vendor."VAT Registration No.";
                            CustArray[1] := Vendor.Name;


                            IF Vendor.BRN <> '' THEN BEGIN
                                CustArray[6] := 'BRN : ' + Vendor.BRN;
                            END;
                            COMPRESSARRAY(CustArray);
                        END;

                        //KTM11/02/22
                        if (CustArray[1] = '') And ("Bal. Account Type" <> "Bal. Account Type"::Customer) then
                            CustArray[1] := "Bank Account Ledger Entry".Payee;
                        if CustArray[1] = '' then
                            CustArray[1] := "Bank Account Ledger Entry"."Student Name";
                        //End KTM11/02/22

                        IF "Bal. Account Type" IN
                         ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor] THEN
                            ClientCode := "Bal. Account No."
                        ELSE
                            ClientCode := '';

                        //KTM11/02/22  
                        Clear(ClientCodeCaption);
                        if ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") then
                            ClientCodeCaption := 'Client Code';

                        //KTM11/02/22

                        CurCod := COPYSTR("Currency Code", 1, 3);
                        IF CurCod = '' THEN BEGIN
                            GLSetup.GET;
                            CurCod := COPYSTR(GLSetup."LCY Code", 1, 3);
                        END;

                        Clear(gdecAmount);
                        CustLedgEntry2.Reset();
                        CustLedgEntry2.SetRange("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
                        CustLedgEntry2.SetRange("Document No.", "Bank Account Ledger Entry"."Document No.");
                        if CustLedgEntry2.FindFirst then begin
                            CustLedgEntry2.CalcFields(Amount);
                            gdecAmount := Abs(CustLedgEntry2.Amount);
                            gtextCurrencyCode := CustLedgEntry2."Currency Code";
                            if gtextCurrencyCode = '' then begin
                                //GLSetup.GET;
                                //gtextCurrencyCode := COPYSTR(GLSetup."LCY Code", 1, 3);
                                gtextCurrencyCode := 'MUR';
                            end;
                        end;

                        IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                            gdecAmount := Amount;

                        //PaymentMethod.SETRANGE(PaymentMethod.Code,"Payment Method");
                        //IF PaymentMethod.FIND('-') THEN
                        // PaymentMethodDesc := PaymentMethod.Description;

                        //KTM 11/02/22 - gdecAmount should not display as negative 
                        // CheckReport.InitTextVariable();
                        // CheckReport.FormatNoText(NumberText, gdecAmount, '');
                        CheckReport.InitTextVariable();
                        CheckReport.FormatNoText(NumberText, Abs(gdecAmount), '');
                        //END KTM 11/02/22



                        CustledgEntry.Reset();
                        CustledgEntry.SETRANGE(CustledgEntry."Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
                        IF CustledgEntry.FIND('-') THEN BEGIN
                            CustledgEntry.CALCFIELDS(CustledgEntry."Remaining Amount");
                            RemAmount := CustledgEntry."Remaining Amount";
                            IF PaymentMethod.Get(CustledgEntry."Payment Method Code") then
                                PaymentMethodDesc := PaymentMethod.Description;
                        END;

                        //KTM11/02/22
                        if PaymentMethodDesc = '' then begin
                            IF PaymentMethod.Get("Payment Method Code") then
                                PaymentMethodDesc := PaymentMethod.Description;
                        end;
                        //END KTM11/02/22

                        IF ("Bank Account Ledger Entry"."Document Type" IN ["Bank Account Ledger Entry"."Document Type"::Payment,
                            "Bank Account Ledger Entry"."Document Type"::Refund]) AND
                            ("Bank Account Ledger Entry"."Bal. Account Type" = "Bank Account Ledger Entry"."Bal. Account Type"::Customer) THEN BEGIN
                            CLEAR(AppliedAmt);
                            CLEAR(UnAppliedAmt);
                            CLEAR(TotalAmt);
                            DetCustLedgerEntry.RESET;
                            DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Entry Type", DetCustLedgerEntry."Entry Type"::Application);
                            DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
                            DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Document No.", "Bank Account Ledger Entry"."Document No.");

                            CASE "Bank Account Ledger Entry"."Document Type" OF
                                "Bank Account Ledger Entry"."Document Type"::Payment:
                                    DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Initial Document Type", DetCustLedgerEntry."Initial Document Type"::Invoice);

                                "Bank Account Ledger Entry"."Document Type"::Refund:
                                    DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Initial Document Type", DetCustLedgerEntry."Initial Document Type"::"Credit Memo");

                            END;

                            DetCustLedgerEntry.SETRANGE(DetCustLedgerEntry."Source Code", 'CASHRECJNL');
                            IF DetCustLedgerEntry.FIND('-') THEN BEGIN

                                REPEAT
                                    AppliedAmt += ABS(DetCustLedgerEntry.Amount);
                                UNTIL DetCustLedgerEntry.NEXT = 0;

                                UnAppliedAmt := 0;
                                TotalAmt := ABS(AppliedAmt) + UnAppliedAmt;
                            END ELSE BEGIN
                                CustLedgerEntry.RESET;
                                CustLedgerEntry.SETRANGE(CustLedgerEntry."Document No.", "Bank Account Ledger Entry"."Document No.");
                                CustLedgerEntry.SETRANGE(CustLedgerEntry."Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
                                CustLedgerEntry.SETRANGE(CustLedgerEntry."Source Code", 'CASHRECJNL');
                                IF CustLedgerEntry.FIND('-') THEN BEGIN

                                    AppliedAmt := 0;
                                    CustLedgerEntry.CALCFIELDS(CustLedgerEntry."Remaining Amount");
                                    UnAppliedAmt := ABS(CustLedgerEntry."Remaining Amount");
                                    TotalAmt := AppliedAmt + ABS(UnAppliedAmt);
                                END;
                            END;

                        END;



                        IF ("Bank Account Ledger Entry"."Document Type" IN ["Bank Account Ledger Entry"."Document Type"::Payment,
                            "Bank Account Ledger Entry"."Document Type"::Refund]) AND

                        ("Bank Account Ledger Entry"."Bal. Account Type" = "Bank Account Ledger Entry"."Bal. Account Type"::"G/L Account") THEN BEGIN
                            CLEAR(AppliedAmt);
                            CLEAR(UnAppliedAmt);
                            CLEAR(TotalAmt);

                            AppliedAmt := 0;
                            UnAppliedAmt := ABS("Bank Account Ledger Entry".Amount);
                            TotalAmt := AppliedAmt + ABS(UnAppliedAmt);
                        END;



                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                        //CurrReport.CREATETOTALS(Amount, RemAmount);//MPLUPG
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //CLEAR(Title[2]);
                    //OutputNo += 1;

                    //IF OutputNo = 2 THEN
                    //Title[2] := Text002
                    //ELSE
                    //CLEAR(Title[2]);
                end;

                trigger OnPostDataItem()
                begin

                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "G/L Register".FIND('-') THEN
                            REPEAT
                            //GLRegisterPrint.RUN("G/L Register");
                            UNTIL "G/L Register".NEXT = 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, 1);
                    //OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF CompanyInfo.GET THEN;
                CompanyInfo.CALCFIELDS(Picture);
                Formataddress.Company(CompanyArr, CompanyInfo);
                Title[1] := Text001;
                CLEAR(Title[2]);
            end;
        }
    }

    trigger OnPostReport()
    begin
        if grecBankAccLedgerEntry.Get("Bank Account Ledger Entry"."Entry No.") then begin
            grecBankAccLedgerEntry."OR No. Printed" += 1;
            grecBankAccLedgerEntry.Modify();
        end;
    end;

    var
        GLRegFilter: Text[250];
        CompanyInfo: Record 79;
        CheckReport: Report 50021;
        NumberText: array[2] of Text[60];
        CurCod: Code[10];
        CustledgEntry: Record 21;
        GL: Record 17;
        GLSetup: Record 98;
        CustArray: array[7] of Text[100];
        Customer: Record 18;
        Vendor: Record 23;
        CompanyArr: array[10] of Text[100];
        Title: array[3] of Text[30];
        PaymentMethod: Record 289;
        PaymentMethodDesc: Text[30];
        ClientCode: Text[30];
        Amts: Decimal;
        RemAmount: Decimal;
        DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        CustLedgerEntry: Record 21;
        IsCopy: Text[4];
        CustBRNText: Text[30];
        CustLabel: Text[10];
        BRNText: Text[30];
        CountryRegion: Record 9;
        DetCustLedgerEntry: Record 379;
        AppliedAmt: Decimal;
        UnAppliedAmt: Decimal;
        TotalAmt: Decimal;
        DetAmount: Decimal;
        AmtInFigures: Decimal;
        BankName: Text[100];
        BankRec: Record 270;
        CurrencyCode: Text[30];
        ParticularsLbl: Text[15];
        ParticularsVal: Text[100];
        DotText: Text[2];
        OutputNo: Integer;
        Text000: Label 'Access Denied!';
        Text001: Label 'ORIGINAL RECEIPT';
        Text002: Label 'COPY';
        Text003: Label 'Payment Receipt';
        Text004: Label 'Payment Voucher';
        Text005: Label 'Page %1';
        Text006: Label 'Pmt. Disc. Given';
        Text007: Label 'Pmt. Disc. Rcvd.';
        Text008: Label 'BRN :';
        Formataddress: Codeunit 365;
        Text009: Label 'VOID RECEIPT';
        CaptionArray: array[5] of Text[50];
        DisplaySection: Boolean;
        VarDocType: Text[30];
        VarVoid: Boolean;
        gdecAmount: Decimal;
        gtextCurrencyCode: Text;
        CustLedgEntry2: Record "Cust. Ledger Entry";
        ltextCurrencyCode: text;
        grecBankAccLedgerEntry: Record "Bank Account Ledger Entry";
        ClientCodeCaption: Text;
}

