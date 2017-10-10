package com.csye6225.demo;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import java.util.UUID;

@Entity // This tells Hibernate to make a table out of this class
public class Task {

    @Id
    private UUID uuid;

    @Column(columnDefinition = "VARCHAR(4096)")
    private String description;

    private Integer userId;

    public UUID getUuid() {
        return uuid;
    }

    public void setUuid() {
        this.uuid = UUID.randomUUID();
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
