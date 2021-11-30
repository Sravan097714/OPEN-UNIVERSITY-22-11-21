page 50062 "Full Prog. From OU Portal"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Full Prog. Fee From OU Protal";
    SourceTableView = where("NAV Doc No." = filter(''));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Validated; Rec.Validated) { ApplicationArea = all; }
                field(RDAP; Rec.RDAP) { ApplicationArea = ALL; }
                field(RDBL; Rec.RDBL) { ApplicationArea = ALL; }
                field(NIC; Rec.NIC) { ApplicationArea = ALL; }
                field("Login Email"; Rec."Login Email") { ApplicationArea = ALL; }
                field("Contact Email"; Rec."Contact Email") { ApplicationArea = ALL; }
                field(Phone; Rec."Phone No.") { ApplicationArea = ALL; }
                field(Mobile; Rec."Mobile No.") { ApplicationArea = ALL; }
                field(Address; Rec.Address) { ApplicationArea = ALL; }
                field(Country; Rec.Country) { ApplicationArea = ALL; }
                field("Imported By"; Rec."Imported By") { ApplicationArea = all; }
                field("Imported DateTime"; Rec."Imported DateTime") { ApplicationArea = all; }
                field(Discount; Rec.Discount) { ApplicationArea = all; }
                field("Discount Amount"; Rec."Discount Amount") { ApplicationArea = all; }
                field(Error; Rec.Error) { ApplicationArea = all; }
                field("Learner ID"; Rec."Learner ID") { ApplicationArea = all; }
                field("MyT Money Ref"; Rec."MyT Money Ref") { ApplicationArea = all; }
                field("Maiden Name"; Rec."Maiden Name") { ApplicationArea = all; }
                field(FullFees; Rec.FullFees) { ApplicationArea = all; }
                field("Payment Amount"; Rec."Payment Amount") { ApplicationArea = all; }
                field("Payment Date"; Rec."Payment Date") { ApplicationArea = all; }
                field("Prog. Code"; Rec."Prog. Code") { ApplicationArea = all; }
                field("Prog. Name"; Rec."Prog. Name") { ApplicationArea = all; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Appl. Fee")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Import Full Program Fee Data.';

                trigger OnAction()
                begin
                    Report.Run(Report::"Full Prog. Fee From OU Protal");
                end;
            }

            action("Validate")
            {
                ApplicationArea = All;
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()

                begin

                end;
            }

            action("Create Sales Invoice")
            {
                ApplicationArea = All;
                Image = CreateJobSalesInvoice;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Create Sales Invoice for Selected Lines.';

                trigger OnAction()
                var
                    FullPgmFee: Record "Full Prog. Fee From OU Protal";
                    ProcessOuPortal: Codeunit "OU Portal Files Scheduler";
                begin
                    CurrPage.SetSelectionFilter(FullPgmFee);
                    ProcessOuPortal.FullPgmFee(FullPgmFee);
                end;
            }

            action(Delete)
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Do you want to delete all the lines.', true) then
                        Rec.DeleteAll();
                end;
            }
        }
    }

    var
        grecGenJnlLine: Record "Gen. Journal Line";
        grecGenJnlLine2: Record "Gen. Journal Line";
        grecSalesReceivableSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        gintCounter: Integer;

}