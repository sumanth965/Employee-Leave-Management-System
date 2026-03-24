package com.elms.util;

import java.util.List;

public class PagedResult<T> {
    private final List<T> items;
    private final int page;
    private final int pageSize;
    private final int totalRecords;

    public PagedResult(List<T> items, int page, int pageSize, int totalRecords) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.totalRecords = totalRecords;
    }

    public List<T> getItems() { return items; }
    public int getPage() { return page; }
    public int getPageSize() { return pageSize; }
    public int getTotalRecords() { return totalRecords; }

    public int getTotalPages() {
        return (int) Math.ceil((double) totalRecords / pageSize);
    }
}
