package com.groovit.groupware.service.impl;

import com.groovit.groupware.mapper.TodoMapper;
import com.groovit.groupware.service.TodoService;
import com.groovit.groupware.vo.TodoVO;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class TodoServiceImpl implements TodoService {

    @Autowired
    private TodoMapper todoMapper;

    @Override
    public List<TodoVO> getAllTodos(String empId) {
        return todoMapper.getAllTodos(empId);
    }

    @Override
    public void addTodo(TodoVO todo) {
        log.debug("Inserting Todo: " + todo.toString());
        String newTodoId = todoMapper.generateNewTodoId();
        log.debug("Generated New Todo ID: " + newTodoId);
        todo.setTodoId(newTodoId);
        todoMapper.insertTodo(todo);
    }

    @Override
    public int updateTodo(TodoVO todoVO) {
        log.debug("Updating Todo: " + todoVO.toString());
        try {
            int rowsAffected = todoMapper.updateTodo(todoVO);
            if (rowsAffected == 0) {
                log.error("No rows affected, update might have failed for Todo ID: {}", todoVO.getTodoId());
                throw new RuntimeException("Update failed, no rows affected");
            }
            return rowsAffected; // 추가된 부분: 성공적으로 업데이트된 행 수 반환
        } catch (Exception e) {
            log.error("Error updating todo", e);
            throw new RuntimeException("Failed to update todo", e);
        }
    }

    @Override
    public void deleteTodoById(String todoId) {
        todoMapper.deleteTodoById(todoId);
    }
}
