report 50050 "Reminder 2"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Reminders for Course Fees';
    RDLCLayout = 'Report\Layout\Reminder.rdl';

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            column(gtextReminder; gtextReminder) { }
            column(GlobalDim1Name2Hdr; gtextGlobalDim1Name2Hdr) { }
            column(GlobalDim2NameHdr; gtextGlobalDim2NameHdr) { }

            column(Name; Name) { }
            column(Address; Address) { }
            column(Address_2; "Address 2") { }
            column(County; County) { }
            column(Deadline_for_Payment; Format("Deadline for Payment", 0, '<Day,2> <Month Text> <Year4>')) { }

            column(CompanyName; grecCompanyInfo.Name) { }
            column(CompanyPicture; grecCompanyInfo.Picture) { }
            column(CompanyAddress; grecCompanyInfo.Address) { }
            column(Signature; grecSalesReceivableSetup."Sign for Reminders") { }

            dataitem("Issued Reminder Line"; "Issued Reminder Line")
            {
                DataItemLink = "Reminder No." = field("No.");
                column(PayableRs; "Original Amount") { }
                column(PaidRs; "Original Amount" - "Remaining Amount") { }
                column(AmountDueRs; "Remaining Amount") { }
                column(Remark; Description) { }
                column(AmountDueRsTotal; AmountDueRsTotal) { }
                column(AmountDueRsTotalGlobal; AmountDueRsTotalGlobal) { }
                column(GlobalDim2Name; gtextGlobalDim2Name) { }
                column(PeriodText; FORMAT(FromDate, 0, '<Month TEXT>-<Year4>' + ' to ' + FORMAT(ToDate, 0, '<Month TEXT>-<Year4>'))) { }

                trigger OnAfterGetRecord()
                begin
                    // if grecDimensionValue.Get('INTAKE', "Global Dimension 2") then
                    //     gtextGlobalDim2Name := grecDimensionValue."Name 2";
                    // if grecDimensionValue."Name 2" = '' then
                    //     gtextGlobalDim2Name := grecDimensionValue.Name;
                    Clear(PeriodText);
                    Clear(FromDate);
                    Clear(ToDate);


                    BankStandinfOrderRec.Reset();
                    BankStandinfOrderRec.SetRange("Invoice Number", "Document No.");
                    if BankStandinfOrderRec.FindFirst() then begin
                        FromDate := BankStandinfOrderRec."From Month";
                        ToDate := BankStandinfOrderRec."To Month";
                    end;
                    AmountDueRsTotal += "Remaining Amount";



                end;

                trigger OnPostDataItem()
                begin
                    AmountDueRsTotalGlobal := AmountDueRsTotal;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if grecDimensionValue.Get('PROGRAMMES', "Shortcut Dimension 1 Code") then
                    gtextGlobalDim1Name2Hdr := grecDimensionValue."Name 2";

                if gtextGlobalDim1Name2Hdr = '' then
                    gtextGlobalDim1Name2Hdr := grecDimensionValue.Name;



                // if grecDimensionValue.Get('INTAKE', "Shortcut Dimension 1 Code") then
                //     gtextGlobalDim1Name2Hdr := grecDimensionValue."Name 2";

                // if gtextGlobalDim1Name2Hdr = '' then
                //     gtextGlobalDim1Name2Hdr := grecDimensionValue.Name;

                // if grecDimensionValue.Get('PROGRAMME', "Shortcut Dimension 2 Code") then
                //     gtextGlobalDim1Name2Hdr := grecDimensionValue."Name 2";
                // if gtextGlobalDim1Name2Hdr = '' then
                //     gtextGlobalDim1Name2Hdr := grecDimensionValue.Name;

                case "Reminder Level" of
                    1:
                        gtextReminder := 'First Reminder';
                    2:
                        gtextReminder := 'Second Reminder';
                    3:
                        gtextReminder := 'Third Reminder';
                end;
            end;
        }
    }

    trigger OnPreReport()
    begin
        grecCompanyInfo.get;
        grecCompanyInfo.CalcFields(Picture);
        grecSalesReceivableSetup.Get();
    end;

    var
        grecCompanyInfo: Record "Company Information";
        grecSalesReceivableSetup: Record "Sales & Receivables Setup";
        grecDimensionValue: Record "Dimension Value";
        gtextGlobalDim2Name: Text;

        gtextGlobalDim1Name2Hdr: Text;
        gtextGlobalDim2NameHdr: Text;
        AmountDueRsTotal: Decimal;
        AmountDueRsTotalGlobal: Decimal;

        gtextReminder: Text;

        FromDate: Date;
        ToDate: Date;
        BankStandinfOrderRec: Record "Bank Standing Orders";
        PeriodText: Text;
}