package com.zstu.crm.vo;

import java.util.List;

public class PaginationVO<T>{
    private Integer total;
    private List<T> datalist;

    @Override
    public String toString() {
        return "PaginationVO{" +
                "total=" + total +
                ", datalist=" + datalist +
                '}';
    }

    public PaginationVO() {
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDatalist() {
        return datalist;
    }

    public void setDatalist(List<T> datalist) {
        this.datalist = datalist;
    }
}
