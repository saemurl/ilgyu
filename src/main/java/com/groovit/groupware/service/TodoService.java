package com.groovit.groupware.service;

import com.groovit.groupware.vo.TodoVO;

import java.util.List;

public interface TodoService {
	List<TodoVO> getAllTodos(String empId);
    void addTodo(TodoVO todoVO);
    int updateTodo(TodoVO todo);
    void deleteTodoById(String todoId);
}
