package com.example.todoapi;

import org.hibernate.dialect.Dialect;

// SQLite Dialect for JPA
public class SQLiteDialect extends Dialect {
    public SQLiteDialect() {
        super();
    }
}