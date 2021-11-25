tableextension 50002 VendorExt extends Vendor
{
    fields
    {
        field(50000; BRN; Text[30]) { }
        field(50001; "Vendor Type"; code[50])
        {
            //OptionMembers = " ","Service Provider",Tutor,Supplier;
            TableRelation = "New Categories".Code where("Table Name" = filter('Vendor'), "Field Name" = filter('Vendor Type'));
            ;
        }
        field(50002; "Vendor Category"; code[50])
        {
            //OptionMembers = " ","SME","Non-SME";
            TableRelation = "New Categories".Code where("Table Name" = filter('Vendor'), "Field Name" = filter('Vendor Category'));
            ;
        }
        field(50003; NID; Text[20])
        {
            //Caption = 'NIC';
        }

        field(50004; Status; Code[50])
        {
            TableRelation = "New Categories".Code where("Table Name" = filter('Vendor'), "Field Name" = filter('Status'));
        }
        field(50005; "No. of Years in Business"; Decimal) { }
        field(50006; "SME Registration Number"; Code[50]) { }
        field(50007; "Name of Client"; Text[250])
        {
            Caption = 'Type of Contracts executed / Name of Clients ';
        }
        field(50008; "TAN Number"; Code[30]) { }
        field(50009; "Representative Name"; Text[100]) { }
        field(50010; "Position Held"; Text[100]) { }
        field(50011; NIC; code[30]) { }
        field(50012; "Representative Address 1"; Text[100]) { }
        field(50013; "Representative Address 2"; Text[100]) { }
        field(50014; "Telephone Number"; Text[30]) { }
        field(50015; "Mobile Number"; Text[30]) { }
        field(50016; "Fax Number"; text[30]) { }
        field(50017; "Email Address"; text[80]) { }
        field(50018; "Date of Registration"; Date) { }
        field(50019; "Date Created"; DateTime) { }
        field(50020; "Created By"; Text[50]) { }
        field(50021; "Bank Accout No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(50022; "Bank Name"; Text[50]) { }
        field(50023; "Bank Address"; Text[100]) { }
        field(50024; IBAN; Code[50]) { }
        field(50025; "SWIFT Code"; Code[20]) { }
        field(50026; "SORT Code"; Code[6]) { }
        field(50027; "Bank Code"; Code[5]) { }

        field(50028; "Surname"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Surname';
        }
        field(50029; "Other Names"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Other Names';
        }
        field(50030; "BSB No"; Code[20]) { }
        field(50031; "BANK SORT CODE"; Code[20]) { }
        field(50032; "BIC"; Code[20]) { }
        field(50033; "IFSC CODE"; Code[20]) { }
        field(50034; "MICR CODE"; Code[20]) { }
        field(50035; "BANK IDENTIFIER CODE"; Code[20]) { }
        field(50036; "BRANCH CODE"; Code[20]) { }
        field(50037; "ROUTING Number"; Code[20]) { }
    }

    trigger OnInsert()
    begin
        "Date Created" := CurrentDateTime;
        "Created By" := UserId;
        "Prices Including VAT" := true;
        "Location Code" := 'MAINSTORE';
    end;
}