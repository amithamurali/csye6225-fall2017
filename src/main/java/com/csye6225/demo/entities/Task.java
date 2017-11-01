package com.csye6225.demo.entities;
/**
 * Amitha_Murali, 001643826, murali.a@husky.neu.edu
 * Jyoti Sharma, 001643410, sharma.j@husky.neu.edu
 * Surabhi Patil, 001251860, patil.sur@husky.neu.edu
 **/

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.util.List;
import java.util.UUID;

@Entity // This tells Hibernate to make a table out of this class
public class Task {


    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")

    private String id;

    @Column(columnDefinition = "VARCHAR(4096)")
    private String description;

    private int userId;

    public String getId() {
        return id;
    }


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

    public List<FileUpload> getFiles() {
        return files;
    }

    //private Long generateUniqueId()
    //{
      //  long val = -1;
       // do
       // {
         //   val = UUID.randomUUID().getMostSignificantBits();
       // } while (val < 0);
        //return val;
    //}
}