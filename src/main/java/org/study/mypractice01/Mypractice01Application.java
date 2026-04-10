package org.study.mypractice01;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan; // 👈 1. 이거 추가!

@SpringBootApplication
@MapperScan("org.study.mypractice01.mapper") // 👈 2. 이거 추가! (통역사들 동네 주소)
public class Mypractice01Application {

    public static void main(String[] args) {
        SpringApplication.run(Mypractice01Application.class, args);
    }
}