package org.study.cafe.chat.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ForeignWordMapper {
    List<Map<String, Object>> findAll();
}
