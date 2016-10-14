package db;


import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by devil1001 on 14.10.16.
 */
public interface ResultHandler {
    void handle(ResultSet result) throws SQLException;
}