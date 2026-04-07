package org.study.brewcrm.customer.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface SchedulerLogMapper {
    int insertLog(Map<String, Object> params);
    List<Map<String, Object>> getRecentLogs(int limit);
}
