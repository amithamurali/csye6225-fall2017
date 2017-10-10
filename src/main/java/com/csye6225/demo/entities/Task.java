package com.csye6225.demo.entities;
/**
 * Amitha_Murali, 001643826, murali.a@husky.neu.edu
 * Jyoti Sharma, 001643410, sharma.j@husky.neu.edu
 * Surabhi Patil, 001251860, patil.sur@husky.neu.edu
 **/

import javax.persistence.*;
import java.util.UUID;

@Entity // This tells Hibernate to make a table out of this class
public class Task {
    @Id
    private UUID id;

    @Column(columnDefinition = "VARCHAR(4096)")
    private String description;

    private int userId;

    public UUID getId() {
        return id;
    }
    public void setId(){ this.id= UUID.randomUUID();  }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

  }
