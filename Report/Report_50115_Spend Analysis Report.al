report 50115 "Spend Analysis Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\SpendAnalysisReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(No_; "No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Order_Date; format("Order Date"))
            {

            }
            column(Posting_Date; format("Posting Date"))
            {

            }
            column(Category_of_Successful_Bidder; "Category of Successful Bidder")
            {

            }
            column(VendorNo; VendorNo)
            {

            }
            column(ItemNo; ItemNo)
            {

            }
            column(POCategory; POCategory)
            {

            }
            column(FromDate; format(FromDate))
            {

            }
            column(ToDate; format(ToDate))
            {

            }
            column(CategoryofSuccessfulbidder; CategoryofSuccessfulbidder)
            {

            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = where(Type = const(Item));
                column(SNNo; SNNo)
                {

                }
                column(PurchLineNo_; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(AmountGvar; AmountGvar)
                {

                }
                trigger OnPreDataItem()
                begin
                    if ItemNo <> '' then
                        SetRange("No.", ItemNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    SNNo += 1;
                    if VAT then
                        AmountGvar := round("Line Amount Excluding VAT")
                    else
                        AmountGvar := round("Line Amount");
                end;
            }
            trigger OnPreDataItem()
            begin
                Clear(SNNo);
                if FromDate = 0D then
                    Error('From Date Must have value');
                if ToDate = 0D then
                    Error('To Date Must have value');
                SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
            end;


        }
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            column(Order_No_; "Order No.")
            {

            }
            column(Buy_from_Vendor_Name_PurchInvHdr; "Buy-from Vendor Name")
            {

            }
            column(Order_Date_PurchInvHdr; format("Order Date"))
            {

            }
            column(Posting_Date_PurchInvHdr; format("Posting Date"))
            {

            }
            column(Category_of_Successful_Bidder_PurchInvHdr; "Category of Successful Bidder")
            {

            }
            column(VendorNo_PurchInvHdr; VendorNo)
            {

            }
            column(ItemNo_PurchInvHdr; ItemNo)
            {

            }
            column(POCategory_PurchInvHdr; POCategory)
            {

            }
            column(FromDate_PurchInvHdr; format(FromDate))
            {

            }
            column(ToDate_PurchInvHdr; format(ToDate))
            {

            }
            column(CategoryofSuccessfulbidder_PurchInvHdr; CategoryofSuccessfulbidder)
            {

            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = const(Item));
                column(SNNo__PurchInvHdr; SNNo)
                {

                }
                column(PurchLineNo__PurchInvHdr; "No.")
                {

                }
                column(Description_PurchInvHdr; Description)
                {

                }
                column(AmountGvar_PurchInvHdr; AmountGvar)
                {

                }
                trigger OnPreDataItem()
                begin
                    if ItemNo <> '' then
                        SetRange("No.", ItemNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    SNNo += 1;
                    if VAT then
                        AmountGvar := round("Line Amount Excluding VAT")
                    else
                        AmountGvar := round("Line Amount");
                end;
            }
            trigger OnPreDataItem()
            begin
                Clear(SNNo);
                if FromDate = 0D then
                    Error('From Date Must have value');
                if ToDate = 0D then
                    Error('To Date Must have value');
                SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
            end;


        }
        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            DataItemTableView = where("Vendor Order No." = filter(<> ''), "Cancelled By" = filter(<> ''));
            column(No_PurchHdrArc; "No.")
            {

            }
            column(Buy_from_Vendor_Name_PurchHdrArc; "Buy-from Vendor Name")
            {

            }
            column(Order_Date_PurchHdrArc; format("Order Date"))
            {

            }
            column(Posting_Date_PurchHdrArc; format("Posting Date"))
            {

            }
            column(Category_of_Successful_Bidder_PurchHdrArc; "Category of Successful Bidder")
            {

            }
            column(VendorNo_PurchHdrArc; VendorNo)
            {

            }
            column(ItemNo_PurchHdrArc; ItemNo)
            {

            }
            column(POCategory_PurchHdrArc; POCategory)
            {

            }
            column(FromDate_PurchHdrArc; format(FromDate))
            {

            }
            column(ToDate_PurchHdrArc; format(ToDate))
            {

            }
            column(CategoryofSuccessfulbidder_PurchHdrArc; CategoryofSuccessfulbidder)
            {

            }
            dataitem("Purchase Line Archive"; "Purchase Line Archive")
            {
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type"), "Doc. No. Occurrence" = field("Doc. No. Occurrence"), "Version No." = field("Version No.");
                DataItemTableView = where(Type = const(Item));
                column(SNNo__PurchHdrArc; SNNo)
                {

                }
                column(PurchLineNo__PurchHdrArc; "No.")
                {

                }
                column(Description_PurchHdrArc; Description)
                {

                }
                column(AmountGvar_PurchHdrArc; AmountGvar)
                {

                }
                trigger OnPreDataItem()
                begin
                    if ItemNo <> '' then
                        SetRange("No.", ItemNo);
                end;

                trigger OnAfterGetRecord()
                begin
                    SNNo += 1;
                    AmountGvar := round("Line Amount");
                end;
            }
            trigger OnPreDataItem()
            begin
                Clear(SNNo);
                if FromDate = 0D then
                    Error('From Date Must have value');
                if ToDate = 0D then
                    Error('To Date Must have value');
                SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
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
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if ToDate <> 0D then
                                if FromDate > ToDate then
                                    Error('From date must be less than To date');
                        end;
                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if FromDate <> 0D then
                                if FromDate > ToDate then
                                    Error('To date must be greater than From date');
                        end;

                    }
                    field("Vendor No"; VendorNo)
                    {
                        TableRelation = Vendor."No.";
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if (ItemNo <> '') or (POCategory <> '') or (CategoryofSuccessfulbidder <> '') then
                                Error('Already filters applied');

                        end;

                    }

                    field("Item No"; ItemNo)
                    {
                        TableRelation = Item."No.";
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if (VendorNo <> '') or (POCategory <> '') or (CategoryofSuccessfulbidder <> '') then
                                Error('Already filters applied');

                        end;

                    }

                    field("PO Category"; POCategory)
                    {
                        TableRelation = "New Categories".Code where("Table Name" = filter('Purchase Header'), "Field Name" = filter('PO Category'));
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if (ItemNo <> '') or (VendorNo <> '') or (CategoryofSuccessfulbidder <> '') then
                                Error('Already filters applied');

                        end;
                    }

                    field("Category of Successful bidder"; CategoryofSuccessfulbidder)
                    {
                        TableRelation = "New Categories".Code where("Table Name" = filter('Purchase Header'), "Field Name" = filter('Category of Successful Bidder'));
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if (ItemNo <> '') or (POCategory <> '') or (VendorNo <> '') then
                                Error('Already filters applied');

                        end;

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
        myInt: Integer;
        FromDate: Date;
        ToDate: Date;
        VendorNo: Code[20];
        ItemNo: Code[20];
        POCategory: Code[20];
        CategoryofSuccessfulbidder: Code[20];
        AmountGvar: Decimal;
        SNNo: Integer;
}