/**
 * Amitha_Murali, 001643826, murali.a@husky.neu.edu
 * Jyoti Sharma, 001643410, sharma.j@husky.neu.edu
 * Surabhi Patil, 001251860, patil.sur@husky.neu.edu
 **/

package com.csye6225.demo.controllers;

import com.csye6225.demo.entities.Task;
import com.csye6225.demo.dao.TaskRepository;
import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.websocket.server.PathParam;

@Controller    // This means that this class is a Controller

public class TaskController {

    @Autowired
    // This means to get the bean called userRepository which is auto-generated by Spring, we will use it to handle the data
    private TaskRepository taskRepository;

    @RequestMapping(value = "/tasks", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public String userTask(HttpServletRequest request, HttpServletResponse response) {

        String taskDescription = request.getParameter("description");

            Task userTask = new Task();
            userTask.setId();
            userTask.setUserId(1);
            userTask.setDescription( taskDescription );
            taskRepository.save( userTask );

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty( "message", "Task has been created successfully for the User." );
            jsonObject.addProperty( "userId", userTask.getUserId() );
           // jsonObject.addProperty( "taskUuid", userTask.getUuid().toString() );
            jsonObject.addProperty( "taskDescription", userTask.getDescription() );

        return jsonObject.toString();
    }

    @RequestMapping(value="/tasks/{id}",method= RequestMethod.PUT,produces="application/json")
    public @ResponseBody String updateTask (HttpServletRequest request){
                                            //@PathParam("id")String id, @RequestParam String description) {

       String taskId = request.getRequestURI().split("/")[2];
       String description = request.getParameter("description");

        JsonObject jsonObject = new JsonObject();

      //  int taskId = Integer.parseInt(id);
        for(Task task:taskRepository.findAll())
        {
            if(task.getId().equals(taskId)) {
                task.setDescription(description);
                taskRepository.save(task);
                jsonObject.addProperty("message", "Task updated successfully.");
                return jsonObject.toString();
                //return Response.ok().status(422).entity(new RestLogicalErrorException("Unknown Error. Please try again")).build();
            }

        }

        jsonObject.addProperty("message", "Error occurred.");
        return jsonObject.toString();

    }

    @RequestMapping(value="/tasks/{id}",method= RequestMethod.DELETE,produces="application/json")
    public @ResponseBody String deleteTask (@PathParam("id")String id) {

        JsonObject jsonObject = new JsonObject();

        int taskId = Integer.parseInt(id);
        for(Task task:taskRepository.findAll())
        {
            if(task.getId().equals(taskId)) {
                taskRepository.delete(task);
                jsonObject.addProperty("message", "Task deleted successfully.");
                return jsonObject.toString();
                //return Response.ok().status(422).entity(new RestLogicalErrorException("Unknown Error. Please try again")).build();
            }

        }

        jsonObject.addProperty("message", "Error occurred.");
        return jsonObject.toString();

    }


}