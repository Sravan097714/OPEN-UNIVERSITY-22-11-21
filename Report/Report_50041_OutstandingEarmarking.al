report 50041 "Earmarking on Purchase Orders"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Earmarking on Purchase Orders';
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\OutstandingEarmarking.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            // DataItemTableView = sorting("No.") where("Document Type" = filter('Order' | 'Invoice' | 'Credit Memo')/*, "Earmark ID" = filter(<> '')*/);//ktm
            DataItemTableView = sorting("No.") where("Document Type" = filter('Order')/*, "Earmark ID" = filter(<> '')*/);

            RequestFilterFields = "Order Date", "No.", "Earmark ID";
            column(gtextDateFilter; gtextDateFilter) { }
            column(CompanyName; grecCompanyInfo.Name) { }
            column(DocNo_; "No.") { }
            column(Order_Date; format("Order Date")) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("G/L Account for Budget" = filter(<> ''));
                RequestFilterFields = "G/L Account for Budget";//ktm
                column(Document_Type; "Document Type") { }
                column(G_L_Account_for_Budget; "G/L Account for Budget") { }//ktm
                column(No_; "No.") { }
                column(gtextAccountType; gtextAccountType) { }
                column(Type; Type) { }
                column(Description; Description) { }
                column(GLName; gtextGLName) { }
                column(Earmark_ID; "Earmark ID") { }
                column(Amount_Earmarked; "Line Amount") { }
                column(Date_Earmarked; format("Date Earmarked")) { }

                trigger OnAfterGetRecord()
                begin
                    clear(gtextGLName);
                    if grecGLAccount.get("G/L Account for Budget") then begin
                        gtextGLName := grecGLAccount.Name;
                        gtextAccountType := format(grecGLAccount."Account Type");
                    end;
                end;

                trigger onpredataitem()
                begin
                    if GLAccountBudget <> '' then
                        SetFilter("G/L Account for Budget", GLAccountBudget);
                end;
            }

            trigger OnPreDataItem()
            begin
                gtextDateFilter := "Purchase Header".GetFilter("Order Date");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("")
                {
                    field("G/L Account for Budget"; GLAccountBudget)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        trigger OnDrillDown()
                        var
                            grecGLAccount: Record "G/L Account";
                            gpageGLAccount: Page "G/L Account List";
                            grecGLAccount2: Record "G/L Account";
                            gtextEarmarkID: Text;
                            grecPurchPayableSetup: Record "Purchases & Payables Setup";
                            gtextCounter: Text;
                            grecPurchHeader: Record "Purchase Header";
                        begin
                            clear(gpageGLAccount);
                            grecGLAccount.Reset();
                            grecGLAccount.SetRange("Account Type", grecGLAccount."Account Type"::Posting);
                            if grecGLAccount.FindFirst() then begin
                                gpageGLAccount.SetRecord(grecGLAccount);
                                gpageGLAccount.SetTableView(grecGLAccount);
                                gpageGLAccount.LookupMode(true);
                                if gpageGLAccount.RunModal() = Action::LookupOK then begin
                                    gpageGLAccount.GetRecord(grecGLAccount);
                                    GLAccountBudget := grecGLAccount."No.";
                                end;
                            end;
                        end;


                    }
                }
            }
        }

    }



    trigger OnPreReport()
    begin
        grecCompanyInfo.get;
    end;


    var
        grecCompanyInfo: Record "Company Information";
        grecGLAccount: Record "G/L Account";
        GLAccountRec: Record "G/L Account";
        GLAccountBudget: Code[20];
        gtextGLName: Text;
        gtextAccountType: Text;
        gtextDateFilter: Text;
}