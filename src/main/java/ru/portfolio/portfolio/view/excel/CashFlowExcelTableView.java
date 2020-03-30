package ru.portfolio.portfolio.view.excel;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.springframework.stereotype.Component;
import ru.portfolio.portfolio.repository.PortfolioRepository;
import ru.portfolio.portfolio.view.Table;
import ru.portfolio.portfolio.view.TableHeader;

import static ru.portfolio.portfolio.view.excel.CashFlowExcelTableHeader.*;

@Component
public class CashFlowExcelTableView extends ExcelTableView {

    public CashFlowExcelTableView(PortfolioRepository portfolioRepository,
                                  CashFlowExcelTableFactory tableFactory) {
        super(portfolioRepository, tableFactory);
    }

    @Override
    protected void writeHeader(Sheet sheet, Class<? extends TableHeader> headerType, CellStyle style) {
        super.writeHeader(sheet, headerType, style);
        sheet.setColumnWidth(CASH.ordinal(), 30 * 256);
        sheet.setColumnWidth(DESCRIPTION.ordinal(), 50 * 256);
        sheet.setColumnWidth(LIQUIDATION_VALUE.ordinal(), 28 * 256);
        sheet.setColumnWidth(PROFIT.ordinal(), 28 * 256);
    }

    @Override
    protected Table.Record getTotalRow() {
        Table.Record total = Table.newRecord();
        total.put(DATE, "Итого:");
        total.put(CASH, "=SUM(" +
                CASH.getColumnIndex() + "3:" +
                CASH.getColumnIndex() + "100000)");
        total.put(LIQUIDATION_VALUE, "0");
        total.put(PROFIT, "=(" + LIQUIDATION_VALUE.getColumnIndex() + "2-" + CASH.getColumnIndex() + "2)"
                + "/SUMPRODUCT("
                + CASH.getColumnIndex() + "2:" + CASH.getColumnIndex() + "100000,"
                + DAYS_COUNT.getColumnIndex() + "2:" + DAYS_COUNT.getColumnIndex() + "100000)*365*100");
        return total;
    }

    @Override
    protected void sheetPostCreate(Sheet sheet, CellStyles styles) {
        super.sheetPostCreate(sheet, styles);
        for (Row row : sheet) {
            if (row.getRowNum() == 0) continue;
            Cell cell = row.getCell(DAYS_COUNT.ordinal());
            if (cell != null) {
                cell.setCellStyle(styles.getIntStyle());
            }
        }
        for (Cell cell : sheet.getRow(1)) {
            if (cell == null) continue;
            if (cell.getColumnIndex() == DATE.ordinal()) {
                cell.setCellStyle(styles.getTotalTextStyle());
            } else if (cell.getColumnIndex() == DAYS_COUNT.ordinal()){
                cell.setCellStyle(styles.getIntStyle());
            } else {
                cell.setCellStyle(styles.getTotalRowStyle());
            }
        }
    }
}