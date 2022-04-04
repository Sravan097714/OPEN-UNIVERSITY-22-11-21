//Inventory Obsolescence Report
/// <summary>
/// Report Inventory Obsolescence Report (ID 50124).
/// </summary>
report 50124 "Inventory Obsolescence Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\InventoryObsolence.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            DataItemTableView = sorting("No.") where(Obsolete = const(true));
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(ReportFilter; ReportFilter) { }
            column(ItemCodeLBL; ItemCodeLBL) { }
            column(No_; "No.") { }
            column(DescriptionLBl; DescriptionLBl) { }
            column(Description; Description) { }
            column(QuantityOnHandLBL; QuantityOnHandLBL) { }
            column(Inventory; Inventory) { }
            column(BaseUnitMeasureLBL; BaseUnitMeasureLBL) { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(UnitCostLbl; UnitCostLbl) { }
            column(Unit_Cost; "Unit Cost") { }
            column(RemarksLBL; RemarksLBL) { }
            column(Reason_for_Obsolete; "Reason for Obsolete") { }


        }
    }

    requestpage
    {
        /*
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
        */

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

    trigger OnPreReport()
    begin
        CompanyInfo.get();
        CompanyInfo.CalcFields(Picture);

        if Item.GetFilter("No.") <> '' then
            NoFilter := 'No. : ' + Item.GetFilter("No.");
        if Item.GetFilter("Item Category Code") <> '' then
            ItemCategoryFilter := ' Item Category : ' + Item.GetFilter("Item Category Code");

        ReportFilter := NoFilter + ItemCategoryFilter;
        if ReportFilter <> '' then
            ReportFilter := 'Report Filter: ' + ReportFilter
    end;

    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ItemCodeLBL: Label 'Item Code';
        DescriptionLBl: Label 'Description';
        QuantityOnHandLBL: Label 'Quantity on hand(Inventory)';
        BaseUnitMeasureLBL: Label 'Base Unit of Measure';
        UnitCostLbl: label 'Unit Cost';
        RemarksLBL: Label 'Remarks';
        NoFilter: Text;
        ItemCategoryFilter: Text;
        ReportFilter: Text;




}