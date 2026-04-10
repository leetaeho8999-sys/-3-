package org.study.mypractice01;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
// 에러 나던 import jdbc 줄을 아예 삭제했습니다!

@SpringBootApplication // (exclude...) 하던 것도 다 지웠습니다!
public class Mypractice01Application {
    public static void main(String[] args) {
        SpringApplication.run(Mypractice01Application.class, args);
    }
}