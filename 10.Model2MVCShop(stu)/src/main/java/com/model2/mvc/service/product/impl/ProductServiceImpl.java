package com.model2.mvc.service.product.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.product.dao.ProductDao;
import com.model2.mvc.service.domain.ProdImage;
import com.model2.mvc.service.domain.Product;

@Service("productServiceImpl")
public class ProductServiceImpl implements ProductService{
	@Autowired
	@Qualifier("productDaoImpl")
	private ProductDao productDao;
	public void setProductDao(ProductDao productDao) {
		System.out.println(":: "+getClass()+".setProductDao() Call.....");
		this.productDao = productDao;
	}
	
	public ProductServiceImpl() {
		// TODO Auto-generated constructor stub
		System.out.println(":: "+getClass()+" default Constructor Call.....");
	}
	
	public int addProduct(Product product) throws Exception {
		int result = productDao.addProduct(product);
		
		for (ProdImage img : product.getImgList())
			productDao.addProdImage(img);
		
		return result;
	}

	public Product getProduct(int prodNo) throws Exception {
		Product product = productDao.getProduct(prodNo);
		product.setImgList(productDao.getProdImgList(prodNo));
		return product;
	}

	public Map<String,Object> getProductList(Search search) throws Exception {
		int totalCount = productDao.getTotalCount(search);
		System.out.println("totalCount :: "+totalCount);
		
		List<Product> list = productDao.getProductList(search);
		
		for (int i=0; i<list.size(); i++) {
			list.get(i).setImgList(productDao.getProdImgList(list.get(i).getProdNo()));
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("totalCount", totalCount);
		map.put("list", list);
		
		return map;
	}

	public int updateProduct(Product Product) throws Exception {
		return productDao.updateProduct(Product);
	}
	
	public int removeProduct(int prodNo) throws Exception {
		return productDao.removeProduct(prodNo);
	}

	@Override
	public int removeProdImage(int imgId) throws Exception {
		// TODO Auto-generated method stub
		return productDao.removeProdImage(imgId);
	}

}
