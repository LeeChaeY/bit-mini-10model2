package com.model2.mvc.service.domain;

public class ProdImage {
	private int imgId;
	private int prodNo;
	private String fileName;

	public ProdImage() {
		// TODO Auto-generated constructor stub
	}

	public ProdImage(int prodNo, String fileName) {
		super();
		this.prodNo = prodNo;
		this.fileName = fileName;
	}

	public int getImgId() {
		return imgId;
	}

	public void setImgId(int imgId) {
		this.imgId = imgId;
	}

	public int getProdNo() {
		return prodNo;
	}

	public void setProdNo(int prodNo) {
		this.prodNo = prodNo;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	@Override
	public String toString() {
		return "ProdImage [imgId=" + imgId + ", prodNo=" + prodNo + ", fileName=" + fileName + "]";
	}

}
