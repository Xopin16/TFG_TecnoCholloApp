package com.salesianostriana.dam.tecnocholloapp.page;

import com.fasterxml.jackson.annotation.JsonView;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserViews;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PageDto<T> {

    @JsonView(UserViews.Master.class)
    private List<T> content;

    @JsonView(UserViews.Master.class)
    private int currentPage;
    @JsonView(UserViews.Master.class)
    private boolean last;
    @JsonView(UserViews.Master.class)
    private boolean first;
    @JsonView(UserViews.Master.class)
    private int totalPages;
    @JsonView(UserViews.Master.class)
    private Long totalElements;

    public PageDto(Page<T> page){
        this.content = page.getContent();
        this.currentPage = page.getNumber();
        this.last = page.isLast();
        this.first = page.isFirst();
        this.totalPages = page.getTotalPages();
        this.totalElements = page.getTotalElements();
    }

}
