report 50115 "Spend Analysis Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\SpendAnalysisReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(SNNo; SNNo)
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
            column(VendorName2; VendorName2)
            {

            }
            column(ItemDescrption; ItemDescrption)
            {

            }
            column(POCategoryDescrption; POCategoryDescrption)
            {

            }
            column(CategoryofSucfulbidderDescrption; CategoryofSucfulbidderDescrption)
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
            column(OrderNo; OrderNo)
            {

            }
            column(OrderDate; format(OrderDate))
            {

            }
            column(PostingDate; format(PostingDate))
            {

            }
            column(VendorName; VendorName)
            {

            }
            column(CategoryofSucbidder; CategoryofSucbidder)
            {

            }
            column(Description; Description)
            {

            }
            column(AmountGvar; Round(AmountGvar))
            {

            }


            trigger OnPreDataItem()
            var
                Item: Record Item;
                Vendor: Record Vendor;
            begin
                Clear(SNNo);
                if FromDate = 0D then
                    Error('From Date Must have value');
                if ToDate = 0D then
                    Error('To Date Must have value');

                NewCategories.Reset();
                NewCategories.SetRange("Table Name", 'Purchase Header');
                NewCategories.SetRange("Field Name", 'PO Category');
                NewCategories.SetRange(Code, POCategory);
                if NewCategories.FindFirst() then
                    POCategoryDescrption := NewCategories.Description;

                NewCategories.Reset();
                NewCategories.SetRange("Table Name", 'Purchase Header');
                NewCategories.SetRange("Field Name", 'Category of Successful Bidder');
                NewCategories.SetRange(Code, CategoryofSuccessfulbidder);
                if NewCategories.FindFirst() then
                    CategoryofSucfulbidderDescrption := NewCategories.Description;

                if Item.Get(ItemNo) then
                    ItemDescrption := Item.Description;

                if Vendor.Get(VendorNo) then
                    VendorName2 := Vendor.Name;

                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    PurchaseHeader.SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    PurchaseHeader.SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    PurchaseHeader.SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
                if PurchaseHeader.FindSet() then
                    repeat
                        PurchaseLine.Reset();
                        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                        //PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                        if ItemNo <> '' then
                            PurchaseLine.SetRange("No.", ItemNo)
                        else
                            PurchaseLine.SetFilter("No.", '<>%1', '');
                        if PurchaseLine.FindSet() then
                            repeat
                                PurchaseLine2.get(PurchaseLine."Document Type", PurchaseLine."Document No.", PurchaseLine."Line No.");
                                PurchaseLine2.Mark(true);
                            until PurchaseLine.Next() = 0;
                    until PurchaseHeader.Next() = 0;


                PurchInvHdr.Reset();
                PurchInvHdr.SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    PurchInvHdr.SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    PurchInvHdr.SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    PurchInvHdr.SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
                if PurchInvHdr.FindSet() then
                    repeat
                        PurchInvLine.Reset();
                        PurchInvLine.SetRange("Document No.", PurchInvHdr."No.");
                        //PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                        if ItemNo <> '' then
                            PurchInvLine.SetRange("No.", ItemNo)
                        else
                            PurchInvLine.SetFilter("No.", '<>%1', '');
                        if PurchInvLine.FindSet() then
                            repeat
                                PurchInvLine2.get(PurchInvLine."Document No.", PurchInvLine."Line No.");
                                PurchInvLine2.Mark(true);
                            until PurchInvLine.Next() = 0;
                    until PurchInvHdr.Next() = 0;




                PurchaseHeaderArc.Reset();
                PurchaseHeaderArc.SetRange("Order Date", FromDate, ToDate);
                if VendorNo <> '' then
                    PurchaseHeaderArc.SetRange("Buy-from Vendor No.", VendorNo);
                if POCategory <> '' then
                    PurchaseHeaderArc.SetRange("PO Category", POCategory);
                if CategoryofSuccessfulbidder <> '' then
                    PurchaseHeaderArc.SetRange("Category of Successful Bidder", CategoryofSuccessfulbidder);
                PurchaseHeaderArc.SetFilter("Vendor Order No.", '<>%1', '');
                PurchaseHeaderArc.SetFilter("Cancelled By", '<>%1', '');
                if PurchaseHeaderArc.FindSet() then
                    repeat
                        PurchaseLineArc.Reset();
                        PurchaseLineArc.SetRange("Document Type", PurchaseHeaderArc."Document Type");
                        PurchaseLineArc.SetRange("Document No.", PurchaseHeaderArc."No.");
                        PurchaseLineArc.SetRange("Doc. No. Occurrence", PurchaseHeaderArc."Doc. No. Occurrence");
                        PurchaseLineArc.SetRange("Version No.", PurchaseHeaderArc."Version No.");
                        //PurchaseLineArc.SetRange(Type, PurchaseLineArc.Type::Item);
                        if ItemNo <> '' then
                            PurchaseLineArc.SetRange("No.", ItemNo)
                        else
                            PurchaseLineArc.SetFilter("No.", '<>%1', '');
                        if PurchaseLineArc.FindSet() then
                            repeat
                                PurchaseLineArc2.get(PurchaseLineArc."Document Type", PurchaseLineArc."Document No.", PurchaseLineArc."Doc. No. Occurrence", PurchaseLineArc."Version No.", PurchaseLineArc."Line No.");
                                PurchaseLineArc2.Mark(true);
                            until PurchaseLine.Next() = 0;
                    until PurchaseHeaderArc.Next() = 0;
                PurchaseLine2.MarkedOnly(true);
                PurchInvLine2.MarkedOnly(true);
                PurchaseLineArc2.MarkedOnly(true);
                PurchArcCount := PurchaseLineArc2.Count;
                PurchCount := PurchaseLine2.Count;
                PurchInvCount := PurchInvLine2.Count;
                SetRange(Number, 1, PurchaseLine2.Count + PurchInvLine2.Count + PurchaseLineArc2.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    if PurchaseLine2.FindFirst() then;
                    if PurchInvLine2.FindFirst() then;
                    if PurchaseLineArc2.FindFirst() then;
                end;
                if (PurchArcCount = 0) and (PurchCount = 0) and (PurchInvCount = 0) then
                    CurrReport.Break();
                SNNo += 1;
                if PurchCount <> 0 then begin
                    Description := PurchaseLine2.Description;
                    // if PurchaseLine2.VAT then
                    //     AmountGvar := PurchaseLine2."Line Amount Excluding VAT"
                    // else
                    //     AmountGvar := PurchaseLine2."Line Amount";
                    AmountGvar := PurchaseLine2."Line Amount";//

                    PurchaseHeader2.get(PurchaseLine2."Document Type", PurchaseLine2."Document No.");
                    OrderDate := PurchaseHeader2."Order Date";
                    PostingDate := PurchaseHeader2."Posting Date";
                    VendorName := PurchaseHeader2."Buy-from Vendor Name";
                    OrderNo := PurchaseHeader2."No.";
                    CategoryofSucbidder := PurchaseHeader2."Category of Successful Bidder";
                    PurchaseLine2.Next();
                end;
                if (PurchCount = 0) and (PurchInvCount <> 0) then begin
                    Description := PurchInvLine2.Description;
                    // if PurchInvLine2.VAT then
                    //     AmountGvar := PurchInvLine2."Line Amount Excluding VAT"
                    // else
                    //     AmountGvar := PurchInvLine2."Line Amount";
                    amountGvar := PurchInvLine2."Line Amount";

                    PurchInvHdr2.get(PurchInvLine2."Document No.");
                    OrderDate := PurchInvHdr2."Order Date";
                    PostingDate := PurchInvHdr2."Posting Date";
                    VendorName := PurchInvHdr2."Buy-from Vendor Name";
                    OrderNo := PurchInvHdr2."Order No.";
                    CategoryofSucbidder := PurchInvHdr2."Category of Successful Bidder";
                    PurchInvLine2.Next();
                end;
                if (PurchCount = 0) and (PurchInvCount = 0) and (PurchArcCount <> 0) then begin

                    Description := PurchaseLineArc2.Description;
                    AmountGvar := PurchaseLineArc2."Line Amount";
                    PurchaseHeaderArc2.get(PurchaseLineArc2."Document Type", PurchaseLineArc2."Document No.", PurchaseLineArc2."Doc. No. Occurrence", PurchaseLineArc2."Version No.");
                    OrderDate := PurchaseHeaderArc2."Order Date";
                    PostingDate := PurchaseHeaderArc2."Posting Date";
                    VendorName := PurchaseHeaderArc2."Buy-from Vendor Name";
                    OrderNo := PurchaseHeaderArc2."No.";
                    CategoryofSucbidder := PurchaseHeaderArc2."Category of Successful Bidder";
                    PurchaseLineArc2.Next();
                end;
                if (PurchCount = 0) and (PurchInvCount = 0) and (PurchArcCount <> 0) then
                    PurchArcCount -= 1;
                if (PurchCount = 0) and (PurchInvCount <> 0) then
                    PurchInvCount -= 1;
                if (PurchCount <> 0) then
                    PurchCount -= 1;
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
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";

        PurchInvHdr: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchaseHeaderArc: Record "Purchase Header Archive";
        PurchaseLineArc: Record "Purchase Line Archive";
        PurchaseHeader2: Record "Purchase Header";
        PurchaseLine2: Record "Purchase Line";

        PurchInvHdr2: Record "Purch. Inv. Header";
        PurchInvLine2: Record "Purch. Inv. Line";
        PurchaseHeaderArc2: Record "Purchase Header Archive";
        PurchaseLineArc2: Record "Purchase Line Archive";
        OrderDate: Date;
        OrderNo: Code[20];
        PostingDate: Date;
        Description: Text;
        VendorName: Text;
        CategoryofSucbidder: Code[20];
        PurchCount: Integer;
        PurchInvCount: Integer;
        PurchArcCount: Integer;
        ItemDescrption: Text;
        POCategoryDescrption: Text;
        CategoryofSucfulbidderDescrption: Text;
        NewCategories: Record "New Categories";
        VendorName2: Text;

}