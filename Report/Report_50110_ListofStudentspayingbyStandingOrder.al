report 50110 "List of Stud payby Stan.Orders"
{
    Caption = 'List of Students paying by Standing Order';
    RDLCLayout = 'Report\Layout\ListofStudpaybyStanOrders.rdl';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Standing Orders"; "Bank Standing Orders")
        {
            // RequestFilterFields = "Name of Bank";
            DataItemTableView = where(Archived = const(false));
            column(BankDetailsContactTitle; BankDetails."Contact Title")
            {

            }
            column(BankDetails_BankName; BankDetails."Bank Name")
            {

            }
            column(BankDetails_ContactDepartment; BankDetails."Contact Department")
            {

            }
            column(BankDetails_Address; BankDetails."Bank Address")
            {

            }
            column(Name_of_Bank; "Name of Bank") { }
            column(Address_2; "Address 2") { }
            column(BankDetails_Address2; BankDetails."Bank Address 2")
            {

            }
            column(Dear_Lbl; Dear_Lbl)
            {

            }
            column(BankStanding_Lbl; BankStanding_Lbl)
            {

            }
            column(PleaseFindTxt; PleaseFindTxt)
            {

            }
            column(YoursFaithfully_Lbl; YoursFaithfully_Lbl)
            {

            }
            column(Sunkoo_Lbl; Sunkoo_Lbl)
            {

            }
            column(FinancialController_Lbl; FinancialController_Lbl)
            {

            }
            column(Companyinfo_PayName; Companyinfo."Payer Name")
            {

            }
            column(Name_Lbl; Name_Lbl)
            {

            }
            column(ListofStudent; ListofStudent)
            {

            }
            column(CourseEnrolled_Lbl; CourseEnrolled_Lbl)
            {

            }
            column(INTAKE_Lbl; INTAKE_Lbl)
            {

            }
            column(Amount_Lbl; Amount_Lbl)
            {

            }
            column(FROM_Lbl; FROM_Lbl)
            {

            }
            column(To_Lbl; To_Lbl)
            {

            }
            column(Period; Period)
            {

            }
            // column(Name_of_Bank_2; "Name of Bank 2")
            // {

            // }
            column(Name_of_Bank_2; LearnerBank)
            {

            }
            column(Sno_Lbl; Sno_Lbl)
            {

            }
            column(Sno; Sno)
            {

            }

            column(Full_Name_of_Applicant; "Full Name of Applicant")
            {

            }
            column(Programme; Programme)
            {

            }
            column(Intake; Intake)
            {

            }
            column(Total_Fee_per_Installment; "Total Fee per Installment")
            {

            }
            column(From_Month; "From Month")
            {

            }
            column(To_Month; "To Month")
            {

            }
            trigger OnPreDataItem()
            var
                BankStandardOrder: Record "Bank Standing Orders";
            begin
                // if BankCode <> '' then
                //     SetRange("Bank Code", BankCode);
                SetRange("Name of Bank", LearnerBank);
                SetRange("From Month", FromDate, ToDate);
                Companyinfo.Get();
                Period := StrSubstNo(PERIOD_Lbl, format(FromDate), format(ToDate));

                BankStandardOrder.CopyFilters("Bank Standing Orders");
                PleaseFindTxt := StrSubstNo(PleaseFind_Lbl, BankStandardOrder.Count, format(FromDate, 0, '<Month Text> <Year4>'));
            end;

            trigger OnAfterGetRecord()
            begin
                if "Name of Bank" <> LearnerBank then
                    CurrReport.Skip();

                BankDetails.SetRange("Bank Name", "Bank Standing Orders"."Name of Bank 2");
                if BankDetails.FindFirst() then;

                Sno += 1;
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
                    /*
                    field("Bank Code"; BankCode)
                    {
                        TableRelation = "Bank Details"."Bank Code";
                        ApplicationArea = all;
                    }
                    */
                    field("Learner Bank"; LearnerBank)
                    {
                        ApplicationArea = all;
                    }
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = all;
                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        ListofStudent: Label 'LIST OF STUDENTS PAYING BY STANDING ORDER';
        Name_Lbl: Label 'Name';
        CourseEnrolled_Lbl: Label 'COURSE ENROLLED';
        INTAKE_Lbl: Label 'INTAKE';
        Amount_Lbl: Label 'AMOUNT PER INST(Rs)';
        FROM_Lbl: Label 'FROM';
        To_Lbl: Label 'TO';
        LearnerBank: Option "ABC BANKING CORPORATION LTD","ABSA BANK (MAURITIUS) LIMITED","AfrAsia BANK LIMITED","BANK OF MAURITIUS LTD","BANK OF BARODA","BANK ONE LIMITED","BCP BANK (MAURITIUS)","BANYAN TREE BANK LTD","DEVELOPMENT BANK OF MAURITIUS","HABIB BANK LIMITED","HONGKONG AND SHANGHAI BANKING CORPORATION LIMITED - MAURITIUS","MauBank LTD","STATE BANK OF MAURITIUS LTD","STANDARD BANK MAURITIUS LTD","THE MAURITIUS COMMERCIAL BANK LIMITED";

        Companyinfo: Record "Company Information";
        BankCode: Code[20];
        FromDate: Date;
        ToDate: Date;
        PERIOD_Lbl: Label 'PERIOD OF %1 TO %2';
        Period: Text;
        Sno: Integer;
        Sno_Lbl: Label 'S No.';
        ContactTitle_Lbl: Label 'Contact Title';
        NameofBank_Lbl: Label 'Name of Bank';
        ContactDepartment_Lbl: Label 'Contact Department';
        Dear_Lbl: Label 'Dear Sir,';
        BankStanding_Lbl: Label 'Bank Standing Order Forms in favour of the Open University of Mauritius';
        PleaseFind_Lbl: Label 'Please find enclosed %1 bank standing order forms applicable with effect from %2. Bank charges are to the order of the students.';
        YoursFaithfully_Lbl: Label 'Yours faithfully,';
        Sunkoo_Lbl: Label 'S. Nunkoo';
        FinancialController_Lbl: Label 'Financial Controller';
        BankDetails: Record "Bank Details";
        PleaseFindTxt: Text;

}