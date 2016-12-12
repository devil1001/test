package db;

import java.sql.ResultSet;
import java.sql.SQLException;
/**
 * Created by devil1001 on 12.12.16.
 */

public interface TResultHandler<T> {
    T handle(ResultSet resultSet) throws SQLException;
}
