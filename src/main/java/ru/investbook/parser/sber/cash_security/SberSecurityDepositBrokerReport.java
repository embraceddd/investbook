/*
 * InvestBook
 * Copyright (C) 2021  Vitalii Ananev <spacious-team@ya.ru>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package ru.investbook.parser.sber.cash_security;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.spacious_team.broker.report_parser.api.BrokerReport;
import org.spacious_team.table_wrapper.excel.ExcelSheet;
import ru.investbook.parser.SecurityRegistrar;

@EqualsAndHashCode(of = "toString")
@ToString(of = "toString", includeFieldNames = false)
@RequiredArgsConstructor
public class SberSecurityDepositBrokerReport implements BrokerReport {
    @Getter
    private final SecurityRegistrar securityRegistrar;

    @Getter
    private final ExcelSheet reportPage;
    private final String toString;

    public SberSecurityDepositBrokerReport(String excelFileName, Workbook book, SecurityRegistrar securityRegistrar) {
        this.reportPage = new ExcelSheet(book.getSheetAt(1));
        this.toString = excelFileName;
        this.securityRegistrar = securityRegistrar;
        checkReportFormat(excelFileName, reportPage);
    }

    public static void checkReportFormat(String excelFileName, ExcelSheet reportPage) {
        Sheet sheet = reportPage.getSheet();
        if (sheet.getSheetName().equals("Движение ЦБ") &&
                reportPage.getRow(0).getCell(0).getStringValue().equals("Номер договора")) {
            return;
        }
        throw new RuntimeException("В файле " + excelFileName + " не содержится отчета движения ЦБ брокера Сбербанк");
    }

    @Override
    public void close() throws Exception {
    }
}
