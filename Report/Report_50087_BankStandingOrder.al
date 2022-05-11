report 50087 "Print Learner Copy"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Layout\BankStandingOrder.rdl';

    dataset
    {
        dataitem("Bank Standing Orders"; "Bank Standing Orders")
        {
            column(Date; Date) { }
            column(Name_of_Bank; "Name of Bank") { }
            column(Address_2; "Address 2") { }
            column(Current_Savings_Account_no_; "Current_Savings Account no.") { }
            column(AmountText; AmountText) { }
            column(Total_Fee_for_Installments; "Total Fee per Installment") { }
            column(From_Month; format("From Month")) { }
            column(To_Month; format("To Month")) { }
            column(Full_Name_of_Applicant; "Full Name of Applicant") { }
            column(National_Identity_No_; "National Identity No.") { }
            trigger OnAfterGetRecord()
            begin
                Clear(AmountText);
                Clear(DescriptionLine);
                // ReportCheck.InitTextVariable();                
                // ReportCheck.FormatNoText(DescriptionLine, "Total Fee for Installments", '');
                InitTextVariable;
                FormatNoText(DescriptionLine, "Total Fee per Installment", '');
                AmountText := DescriptionLine[1] + '' + DescriptionLine[2];
            end;
        }
    }

    var
        grecCompanyInfo: Record "Company Information";
        AmountText: Text;
        DescriptionLine: array[2] of Text[70];
        ReportCheck: Report Check;

        Text029: Label '%1 results in a written number that is too long.';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        ExponentText: array[5] of Text[30];
        Text10800: Label 'EUROS';
        Text10801: Label 'CENT';
        Currency: Record Currency;
        Text068: Label 'CENTS';
        Text066: Label 'ONLY';
        Text067: Label '';//This was 'RUPEES'
        x: Integer;
        y: Integer;
        NewNo: Integer;
        CentText: Text[30];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];

    procedure FormatNoText(var NoText: array[2] of Text[70]; No: Decimal; CurrencyCode: Code[10])
    begin
        //>>TBS82
        //IF (CurrencyCode = '') OR (CurrencyCode = 'FRF') THEN
        if CurrReport.Language = 1036 then
            //<<TBS82
            FormatNoTextFR(NoText, No, CurrencyCode)
        else
            FormatNoTextINTL(NoText, No, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[70]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;



    procedure FormatNoTextFR(var NoText: array[2] of Text[70]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;

                if Hundreds = 1 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027)
                else begin
                    if Hundreds > 1 then begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                        if (Tens * 10 + Ones) = 0 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027 + 'S')
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                    end;
                end;

                FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                if PrintExponent and (Exponent > 1) then
                    if ((Hundreds * 100 + Tens * 10 + Ones) > 1) and (Exponent <> 2) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 'S')
                    else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode = '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text10800)
        else begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, UpperCase(Currency.Description));
        end;

        No := No * 100;
        Ones := No mod 10;
        Tens := No div 10;
        FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

        if (CurrencyCode = '') or (CurrencyCode = 'FRF') then
            case true of
                No = 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801);
                No > 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801 + 'S');
            end;
    end;


    procedure FormatTens(var NoText: array[2] of Text[70]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer)
    begin
        case Tens of
            9:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                end;

            8:
                begin
                    if Ones = 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text057 + 'S')
                    else begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text057);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    end;
                end;

            7:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text055);
                    if Ones = 1 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                end;

            2:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text051);
                    if Ones > 0 then begin
                        if Ones = 1 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    end;
                end;

            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);

            0:
                begin
                    if Ones > 0 then
                        if (Ones = 1) and (Hundreds < 1) and (Exponent = 2) then
                            PrintExponent := true
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end;

            else begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then begin
                        if Ones = 1 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, 'ET');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    end;
                end;
        end;
    end;


    procedure FormatNoTextINTL(var NoText: array[2] of Text[70]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if No <> 0 then begin
            No := No * 100;
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text067);
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
            if No < 20 then begin

                for x := 1 to 19 do begin
                    if No = x then
                        CentText := OnesText[x];
                end;
            end else begin
                if No >= 20 then begin
                    NewNo := No div 10;
                    for x := 2 to 9 do begin
                        if NewNo = x then begin
                            CentText := TensText[x];
                            No := No mod 10;
                            for y := 1 to 9 do begin
                                if No = y then
                                    CentText := CentText + ' ' + OnesText[y];
                            end;
                        end;
                    end;
                end;
            end;
            AddToNoText(NoText, NoTextIndex, PrintExponent, CentText);
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text068);
            AddToNoText(NoText, NoTextIndex, PrintExponent, '' + Text066);
        end else begin
            if No = 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text067);
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text066);
        end;

        if CurrencyCode <> '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;


}