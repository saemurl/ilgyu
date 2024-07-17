package com.groovit.groupware.mapper;

import com.groovit.groupware.vo.TodoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TodoMapper {

    List<TodoVO> getAllTodos(@Param("empId") String empId);

    String generateNewTodoId();
    void insertTodo(TodoVO todoVO);

    int updateTodo(TodoVO todo);

    void deleteTodoById(@Param("todoId") String todoId);
}
