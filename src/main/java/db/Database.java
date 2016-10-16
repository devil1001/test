package db;

import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by devil1001 on 14.10.16.
 */



public class Database {

    BasicDataSource dataSource;

    public Database() {
        dataSource = new BasicDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/db_techopark");
        dataSource.setUsername("www-data");
        dataSource.setPassword("technopark");

        try {
            execUpdate("SET NAMES utf8 COLLATE utf8_unicode_ci");
        } catch (SQLException e) {}

    }

    @Override
    @SuppressWarnings("OverlyBroadThrowsClause")
    protected void finalize() throws Throwable {
        dataSource.close();
        super.finalize();
    }

    public void execQuery(String query, ResultHandler handler) throws SQLException {
        try (Connection connection = dataSource.getConnection()) {
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(query);
                ResultSet result = stmt.getResultSet();
                handler.handle(result);
                result.close();
            }
        }
    }

    public int execUpdate(String update) throws SQLException {
        try (Connection connection = dataSource.getConnection()) {
            try (Statement stmt = connection.createStatement()) {
                stmt.executeUpdate(update, Statement.RETURN_GENERATED_KEYS);
                int res = -1;

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        res = rs.getInt(1);
                    }
                }

                return res;
            }
        }
    }

}