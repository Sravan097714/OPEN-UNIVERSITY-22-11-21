//Print Remittance Voucher for Supplier
page 50074 "Print Remitt. Voucher Supplier"
{
    ApplicationArea = All;
    Caption = 'Print Remittance Voucher for Supplier';
    DataCaptionFields = "Vendor No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    Permissions = TableData "Vendor Ledger Entry" = m;
    PromotedActionCategories = 'New,Process,Report,Line,Entry';
    SourceTable = "Vendor Ledger Entry";
    //ktm  
    // SourceTableView = SORTING("Entry No.")
    //                   ORDER(Descending) where("Source Code" = filter('PAYMENTJNL'), "Vendor Category" = filter('<>PAYROLL'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Print; Print) { ApplicationArea = All; }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = true;
                }
                field("Message to Recipient"; "Message to Recipient")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                    Visible = true;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = Intercompany;
                    Editable = false;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.';
                    Visible = false;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                    Editable = false;
                }
                field("Payment Reference"; "Payment Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                    Visible = false;
                    Editable = false;
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                    Visible = false;
                }
                field("Original Amount"; "Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field("Original Amt. (LCY)"; "Original Amt. (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that the entry originally consisted of, in LCY.';
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry.';
                    Visible = false;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                    Visible = false;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                    Visible = true;
                    Editable = false;
                }
                field("Debit Amount (LCY)"; "Debit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in LCY.';
                    Visible = true;
                    Editable = false;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                    Visible = true;
                    Editable = false;
                }
                field("Credit Amount (LCY)"; "Credit Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the ledger entries that represent credits, expressed in LCY.';
                    Visible = true;
                    Editable = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Remaining Amt. (LCY)"; "Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    ToolTip = 'Specifies the amount that remains to be applied to before the entry is totally applied to.';
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.';
                    Visible = true;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.';
                    Visible = true;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.';
                    Editable = false;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                    Visible = false;
                }
                field("Pmt. Disc. Tolerance Date"; "Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                    Visible = false;
                }
                field("Original Pmt. Disc. Possible"; "Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                    Visible = false;
                }
                field("Remaining Pmt. Disc. Possible"; "Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';
                    Visible = false;
                }
                field("Max. Payment Tolerance"; "Max. Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                    Visible = false;
                }
                field(Open; Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.';
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = true;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation("User ID");
                    end;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                    Visible = true;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field(Reversed; Reversed)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.';
                    Visible = false;
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.';
                    Visible = false;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                    Visible = false;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Exported to Payment File"; "Exported to Payment File")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.';
                    Visible = false;

                    trigger OnValidate()
                    var
                        ConfirmManagement: Codeunit "Confirm Management";
                    begin
                        if not ConfirmManagement.GetResponseOrDefault(ExportToPaymentFileConfirmTxt, true) then
                            Error('');
                    end;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
                    Visible = true;
                    Editable = false;
                }
                field(RecipientBankAcc; "Recipient Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account to transfer the amount to.';
                    Editable = false;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("PV Number"; Rec."PV Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Type"; "Payment Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("TDS Code"; "TDS Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(VAT; VAT)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Retention Fee"; "Retention Fee")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Payee; Payee)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Category"; "Vendor Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor Type"; "Vendor Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment Journal No."; "Payment Journal No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        /* area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                SubPageLink = "Posting Date" = field("Posting Date"), "Document No." = field("Document No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        } */
    }

    actions
    {
        area(Processing)
        {
            action("Select All")
            {
                ApplicationArea = All;
                Image = Select;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    grecVendLdgEntries: Record "Vendor Ledger Entry";
                begin
                    grecVendLdgEntries.Reset();
                    grecVendLdgEntries.SetRange("Vendor Category", 'TUTOR');
                    grecVendLdgEntries.SetRange("Source Code", 'PAYMENTJNL');
                    if grecVendLdgEntries.FindSet() then
                        grecVendLdgEntries.ModifyAll(Print, true);
                    CurrPage.Update(true);
                end;
            }

            action("Unselect All")
            {
                ApplicationArea = All;
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    grecVendLdgEntries: Record "Vendor Ledger Entry";
                begin
                    grecVendLdgEntries.Reset();
                    grecVendLdgEntries.SetRange("Vendor Category", 'TUTOR');
                    grecVendLdgEntries.SetRange("Source Code", 'PAYMENTJNL');
                    if grecVendLdgEntries.FindSet() then
                        grecVendLdgEntries.ModifyAll(Print, false);
                    CurrPage.Update(true);
                end;
            }

            action("Print Remittance Voucher")
            {
                ApplicationArea = All;
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    grecVendLdgEntries: Record "Vendor Ledger Entry";
                    grepRemittance: Report "Remittance Voucher Detailed";
                begin
                    grecVendLdgEntries.Reset();
                    grecVendLdgEntries.SETFILTER("Vendor Category", '<>%1&<>%2', 'TUTOR', 'PAYROLL');
                    grecVendLdgEntries.SetRange("Source Code", 'PAYMENTJNL');
                    grecVendLdgEntries.SetRange(Print, true);
                    if grecVendLdgEntries.FindSet() then begin
                        //Message(format(grecVendLdgEntries.Count));
                        grepRemittance.SetTableView(grecVendLdgEntries);
                        grepRemittance.UseRequestPage := false;
                        grepRemittance.Run();
                    end;
                    //Report.Run(50058, false, false, grecVendLdgEntries);
                end;
            }

            action("Send Email")
            {
                ApplicationArea = All;
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                /*
                ktm
                                trigger OnAction()
                                var
                                    grecVendLdgEntries: Record "Vendor Ledger Entry";
                                    gintCount: Integer;
                                begin
                                    if Confirm('Do you want to email Remittance Vouchers?', true) then begin
                                        grecVendLdgEntries.Reset();
                                        grecVendLdgEntries.SetRange("Vendor Category", 'TUTOR');
                                        grecVendLdgEntries.SetRange("Source Code", 'PAYMENTJNL');
                                        grecVendLdgEntries.SetRange(Print, true);
                                        if grecVendLdgEntries.FindSet() then begin
                                            repeat

                                                gintCount += 1;
                                            until grecVendLdgEntries.Next = 0;
                                            Message('Email has been sent for %1 tutors.', gintCount);
                                        end;
                                    end;
                                end;
                                */
                trigger OnAction()
                var
                    grecVendLdgEntries: Record "Vendor Ledger Entry";
                begin

                    grecVendLdgEntries.Reset();
                    grecVendLdgEntries.SETFILTER("Vendor Category", '<>%1&<>%2', 'TUTOR', 'PAYROLL');
                    grecVendLdgEntries.SetRange("Source Code", 'PAYMENTJNL');
                    grecVendLdgEntries.SetRange(Print, true);
                    if grecVendLdgEntries.FindSet() then begin
                        repeat
                            SendEmail(grecVendLdgEntries."Entry No.");
                        until grecVendLdgEntries.Next() = 0;
                    end;
                    Message('Email Succesfully sent');
                    //Report.Run(50058, false, false, grecVendLdgEntries);
                end;

            }
        }
    }



    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("Document No.", "Posting Date");
        HasDocumentAttachment := HasPostedDocAttachment;

    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnInit()
    begin
        AmountVisible := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", Rec);
        //exit(false);
    end;

    trigger OnOpenPage()
    begin
        //SetControlVisibility;
        if GetFilters <> '' then
            if FindFirst then;

        //KTM
        // Rec.SetView(StrSubstNo('Sorting ("Entry No.") order (descending) where ("Source Code" = filter(PAYMENTJNL), "Vendor Category" = filter(<> PAYROLL | <> TUTOR)'));
        // Rec.FilterGroup(1);
        Rec.SetFilter("Vendor Category", '<>%1&<>%2', 'PAYROLL', 'TUTOR');
        Rec.SetFilter("Source Code", 'PAYMENTJNL');

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        ModifyAll(Print, false);
    end;

    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
        CreatePayment: Page "Create Payment";
        StyleTxt: Text;
        HasIncomingDocument: Boolean;
        HasDocumentAttachment: Boolean;
        AmountVisible: Boolean;
        DebitCreditVisible: Boolean;
        VendNameVisible: Boolean;
        ExportToPaymentFileConfirmTxt: Label 'Editing the Exported to Payment File field will change the payment suggestions in the Payment Journal. Edit this field only if you must correct a mistake.\Do you want to continue?';


    /// <summary>
    /// SendEmail.
    /// </summary>
    /// <param name="VendLedEntryRec">Record "Vendor Ledger Entry".</param>
    /// 
    /*
    procedure SendEmail(EntryNo: Integer)
    var
        FileName: Text;
        VendLedEntryRecLocal: Record "Vendor Ledger Entry";
        FileMgt: Codeunit "File Management";
        grepRemittance: Report "Remittance Voucher Detailed";
        VendorRec: Record Vendor;
        SMTP: Codeunit "SMTP Mail";
        Attachment: Text;
        SenderName: Text[250];
        SenderAddress: Text[250];
        Recepient: list of [text];
        Subject: Text[250];
        InStrm: InStream;
        HonorificText: Label 'Sir / Madam';
        OutStrm: OutStream;
        EmailBigTxt: BigText;
        CompanyInfo: Record "Company Information";
        NewBody: Label '<p><br><br>Dear %1 ,<br><br> Please find attached copy of your remittance advice . <br><br>Kind regards,<br><br><br><Strong>Finance Division<Strong><br><Strong>%2<Strong></p>';
        Body: Text;
    begin

        VendLedEntryRecLocal.Get(EntryNo);

        FileName := FileMgt.GetDirectoryName(FileMgt.ServerTempFileName('pdf')) + '\' + STRSUBSTNO('%1 %2.pdf', 'Remittance Voucher', VendLedEntryRecLocal."PV Number");
        IF EXISTS(FileName) THEN
            ERASE(FileName);

        Clear(Body);
        Clear(Recepient);



        CompanyInfo.Get;
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("E-Mail");
        SenderName := CompanyInfo.Name;
        SenderAddress := CompanyInfo."E-Mail";
        Subject := 'Remitt. Voucher';

        if VendorRec.Get(VendLedEntryRecLocal."Vendor No.") then;
        Body := StrSubstNo(NewBody, HonorificText, CompanyInfo.Name);

        CLEAR(grepRemittance);
        grepRemittance.Setfilter(EntryNo);
        grepRemittance.SETTABLEVIEW(VendLedEntryRecLocal);
        grepRemittance.USEREQUESTPAGE(FALSE);
        IF grepRemittance.SAVEASPDF(FileName) THEN BEGIN
            Recepient.Add(VendorRec."E-Mail");
            SMTP.CreateMessage(SenderName, SenderAddress, Recepient, Subject, '');
            SMTP.AppendBody(StrSubstNo(Body));

            SMTP.AddAttachment(FileName, Attachment);
            SMTP.Send;

        end;
    end;
    */

    procedure SendEmail(EntryNo: Integer)
    var
        FileName: Text;
        VendLedEntryRecLocal: Record "Vendor Ledger Entry";
        FileMgt: Codeunit "File Management";
        grepRemittance: Report "Remittance Voucher Detailed";
        VendorRec: Record Vendor;
        // SMTP: Codeunit "SMTP Mail";
        Attachment: Text;
        SenderName: Text[250];
        SenderAddress: Text[250];
        Recepient: list of [text];
        Subject: Text[250];
        InStrm: InStream;
        HonorificText: Label 'Sir / Madam';
        OutStrm: OutStream;
        EmailBigTxt: BigText;
        CompanyInfo: Record "Company Information";
        NewBody: Label '<p><br><br>Dear %1 ,<br><br> Please find attached copy of your remittance advice . <br><br>Kind regards,<br><br><br><Strong>Finance Division<Strong><br><Strong>%2<Strong></p>';
        Body: Text;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        AttachmentInStream: InStream;
        AttachmentOutStream: OutStream;
        Parameters: Text;
        RecRef: RecordRef;
        XParameter: text;
        TempFile: File;
        MemoryStream: DotNet MemoryStream;
    begin

        VendLedEntryRecLocal.Get(EntryNo);

        FileName := FileMgt.GetDirectoryName(FileMgt.ServerTempFileName('pdf')) + '\' + STRSUBSTNO('%1 %2.pdf', 'Remittance Voucher', VendLedEntryRecLocal."PV Number");
        IF EXISTS(FileName) THEN
            ERASE(FileName);

        Clear(Body);
        Clear(Recepient);
        Clear(SenderAddress);
        Clear(SenderName);
        Clear(Subject);


        CompanyInfo.Get;
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("E-Mail");
        Subject := 'Remitt. Voucher';

        if VendorRec.Get(VendLedEntryRecLocal."Vendor No.") then;
        Body := StrSubstNo(NewBody, HonorificText, CompanyInfo.Name);

        CLEAR(grepRemittance);
        grepRemittance.Setfilter(EntryNo);
        grepRemittance.SETTABLEVIEW(VendLedEntryRecLocal);
        grepRemittance.USEREQUESTPAGE(FALSE);
        IF grepRemittance.SAVEASPDF(FileName) THEN BEGIN

            EmailMessage.Create(VendorRec."E-Mail", Subject, Body, true);
            
            TempFile.OPEN(FileName);
            TempFile.CREATEINSTREAM(AttachmentInStream);

            TempBlob.CREATEOUTSTREAM(AttachmentOutstream);
            COPYSTREAM(AttachmentOutstream, AttachmentInStream);
            TempBlob.CREATEINSTREAM(AttachmentInStream);

            MemoryStream := MemoryStream.MemoryStream();
            COPYSTREAM(MemoryStream, AttachmentInStream);
            EmailMessage.AddAttachment('Remitt Voucher.pdf', 'PDF', MemoryStream);
            Email.Send(EmailMessage, Enum::"Email Scenario"::"Remittance Voucher");
            TempFile.Close();

        end;
    end;

}

