report 50130 "HEC"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\HEC.rdl';

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            DataItemTableView = sorting(Name) where("Dimension Value Type" = const(Standard), "Dimension Code" = filter('PROGRAMMES'));
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(ReportTitle; ReportTitle) { }
            column(ProgramOfStudy; ProgramOfStudy + ': ' + "Name 2") { }
            column(DateFilter; DateFilter) { }
            column(TutionFeesTotal; TutionFeesTotal) { }


            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = where("Gov Grant" = const(true));
                RequestFilterFields = "Posting Date";
                DataItemLinkReference = "Dimension Value";
                DataItemLink = "Shortcut Dimension 1 Code" = field(Code);

                column(SLNo; SLNo) { }
                column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
                column(NIC; NIC) { }
                column(Last_Name; "Last Name") { }
                column(Maiden_Name; "Maiden Name") { }
                column(First_Name; "First Name") { }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
                column(Credit_0; ModuleCredit[1]) { }
                column(Credit_1; ModuleCredit[2]) { }
                column(Credit_15; ModuleCredit[3]) { }
                column(Credit_2; ModuleCredit[4]) { }
                column(Credit_3; ModuleCredit[5]) { }
                column(Credit_4; ModuleCredit[6]) { }
                column(Credit_45; ModuleCredit[7]) { }
                column(Credit_5; ModuleCredit[8]) { }
                column(Credit_6; ModuleCredit[9]) { }
                column(Credit_65; ModuleCredit[10]) { }
                column(Credit_7; ModuleCredit[11]) { }
                column(Credit_75; ModuleCredit[12]) { }
                column(Credit_8; ModuleCredit[13]) { }
                column(Credit_85; ModuleCredit[14]) { }
                column(Credit_9; ModuleCredit[15]) { }
                column(Credit_95; ModuleCredit[16]) { }
                column(Credit_10; ModuleCredit[17]) { }
                column(Credit_12; ModuleCredit[18]) { }
                column(Credit_13; ModuleCredit[19]) { }
                column(Credit_15_; ModuleCredit[20]) { }
                column(Credit_20; ModuleCredit[21]) { }
                column(Credit_24; ModuleCredit[22]) { }
                column(Credit_30; ModuleCredit[23]) { }
                column(Credit_50; ModuleCredit[24]) { }
                column(Tution_Fees; TutionFees) { }

                trigger OnAfterGetRecord()
                begin
                    SLNo += 1;
                    TutionFees := 0;

                    Clear(ModuleCredit);

                    with SalesheaderRec do begin
                        SetRange("Shortcut Dimension 1 Code", "Sales Header"."Shortcut Dimension 1 Code");
                        SetRange("Gov Grant", true);
                        SetRange("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                        if Find('-') then begin
                            repeat
                                //
                                SalesLineRec.Reset();
                                SalesLineRec.SetRange("Document Type", SalesheaderRec."Document Type");
                                SalesLineRec.SetRange("Document No.", SalesheaderRec."No.");
                                if SalesLineRec.find('-') then begin
                                    repeat
                                        TutionFees += SalesLineRec.Amount;

                                        //Credit Module
                                        case SalesLineRec."Module Credit" of
                                            0:
                                                ModuleCredit[1] += 1;
                                            1:
                                                ModuleCredit[2] += 1;
                                            1.5:
                                                ModuleCredit[3] += 1;
                                            2:
                                                ModuleCredit[4] += 1;
                                            3:
                                                ModuleCredit[5] += 1;
                                            4:
                                                ModuleCredit[6] += 1;
                                            4.5:
                                                ModuleCredit[6] += 1;
                                            //
                                            5:
                                                ModuleCredit[8] += 1;
                                            6:
                                                ModuleCredit[9] += 1;
                                            6.5:
                                                ModuleCredit[10] += 1;
                                            7:
                                                ModuleCredit[11] += 1;
                                            7.5:
                                                ModuleCredit[12] += 1;
                                            8:
                                                ModuleCredit[13] += 1;
                                            8.5:
                                                ModuleCredit[14] += 1;
                                            9:
                                                ModuleCredit[15] += 1;
                                            9.5:
                                                ModuleCredit[16] += 1;
                                            10:
                                                ModuleCredit[17] += 1;
                                            12:
                                                ModuleCredit[18] += 1;
                                            13:
                                                ModuleCredit[19] += 1;
                                            15:
                                                ModuleCredit[20] += 1;
                                            20:
                                                ModuleCredit[21] += 1;
                                            24:
                                                ModuleCredit[22] += 1;
                                            30:
                                                ModuleCredit[23] += 1;
                                            50:
                                                ModuleCredit[24] += 1;
                                        end;
                                    //end credit module
                                    until SalesLineRec.Next() = 0;
                                end;


                            //
                            until Next() = 0;

                        end;
                    end;


                end;

            }
            trigger OnPreDataItem()
            begin
                SetRange(Code, ProgramValueCode);
            end;

            trigger OnAfterGetRecord()
            begin
                SalesheaderRec2.Reset();
                SalesheaderRec2.CopyFilters(SalesheaderRec3);

                SalesheaderRec2.SetRange("Shortcut Dimension 1 Code", Code);
                if SalesheaderRec2.Find('-') then begin
                    repeat
                        SalesheaderRec2.CalcFields(Amount);

                        TutionFeesTotal += SalesheaderRec2.Amount;
                    until SalesheaderRec2.Next() = 0;
                end;



            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Programme"; ProgramValueCode)
                    {
                        ApplicationArea = All;
                        trigger OnDrillDown()
                        var
                            DimensionValuePage: Page "Dimension Values";
                            DimensionValueRec: Record "Dimension Value";
                        begin
                            DimensionValueRec.Reset();
                            Clear(DimensionValuePage);

                            DimensionValueRec.SetRange("Dimension Value Type", DimensionValueRec."Dimension Value Type"::Standard);
                            DimensionValueRec.SetFilter("Dimension Code", 'PROGRAMMES');

                            DimensionValuePage.SetRecord(DimensionValueRec);
                            DimensionValuePage.SetTableView(DimensionValueRec);

                            DimensionValuePage.LookupMode(true);
                            if DimensionValuePage.RunModal() = Action::LookupOK then begin
                                DimensionValuePage.GetRecord(DimensionValueRec);
                                ProgramValueCode := DimensionValueRec.Code;
                            end;
                        end;

                    }
                }
            }
        }


    }

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);

        if ProgramValueCode = '' then
            Error('Programme Code must be selected');

        DateFilter := "Sales Header".GetFilter("Posting Date");
        SalesheaderRec3.CopyFilters("Sales Header");

    end;

    var
        ReportTitle: Label 'Detailed Schedule for Disbursement of Fees (Registration by Module)';
        ProgramOfStudy: Label 'Programme of Study';
        CompanyInfo: Record "Company Information";
        TutionFeesTotal: Decimal;
        ProgramValueCode: Code[20];
        TutionFees: Decimal;
        SalesheaderRec: record "Sales Header";
        SalesheaderRec2: record "Sales Header";
        SalesheaderRec3: record "Sales Header";


        SalesLineRec: Record "Sales Line";
        SLNo: Integer;

        DateFilter: Text;

        ModuleCredit: array[24] of Integer;

}