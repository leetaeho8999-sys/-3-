package org.study.mypractice01.vo;

import lombok.Data;

@Data // Getter, Setter, toString을 알아서 만들어주는 마법의 단어입니다.
public class MemberVO {
    private String m_id;
    private String m_pw;
    private String m_name;
    private String m_phone;
    private String m_email;
}