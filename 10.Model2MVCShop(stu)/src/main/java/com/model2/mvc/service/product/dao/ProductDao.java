package com.model2.mvc.service.product.dao;

import java.util.List;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.ProdImage;
import com.model2.mvc.service.domain.Product;

public interface ProductDao {

	public int addProduct(Product product) throws Exception;

	public Product getProduct(int prodNo) throws Exception;

	public List<Product> getProductList(Search search) throws Exception;

	public int updateProduct(Product product) throws Exception;
	
	public int removeProduct(int prodNo) throws Exception;

	// �Խ��� Page ó���� ���� ��ü Row(totalCount)  return
	public int getTotalCount(Search search) throws Exception;
	
	
	
	public int addProdImage(ProdImage prodImage) throws Exception;
	
	public List<ProdImage> getProdImgList(int prodNo) throws Exception;
	
	public ProdImage getProdImage(int imgId) throws Exception;
	
	public int removeProdImage(int imgId) throws Exception;
	
	public int getSeq_product_prod_no() throws Exception;
	
	public List<String> getProdNameList() throws Exception;

}
