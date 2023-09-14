package com.model2.mvc.service.product.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.ProdImage;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.dao.ProductDao;

@Repository("productDaoImpl")
public class ProductDaoImpl implements ProductDao {
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		System.out.println(":: "+getClass()+".setSqlSession() Call.....");
		this.sqlSession = sqlSession;
	}

	public ProductDaoImpl() {
		System.out.println(":: "+getClass()+" default Constructor Call.....");
	}
	
	@Override
	public int addProduct(Product product) throws Exception {
		return sqlSession.insert("ProductMapper.addProduct", product);
	}

	@Override
	public Product getProduct(int prodNo) throws Exception {
		Product product = sqlSession.selectOne("ProductMapper.getProduct", prodNo);
		if (product.getProTranCode() != null)
			product.setProTranCode(product.getProTranCode().trim());
		
		return product;
	}
	
	@Override
	public int updateProduct(Product product) throws Exception {
		return sqlSession.update("ProductMapper.updateProduct", product);
	}
	
	@Override
	public int removeProduct(int prodNo) throws Exception {
		return sqlSession.delete("ProductMapper.removeProduct", prodNo);
	}

	@Override
	public List<Product> getProductList(Search search) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("beginPrice", -1);
		map.put("endPrice", -1);
		if (search.getSearchKeyword() != null && !search.getSearchKeyword().equals("")) {
			if (search.getSearchCondition().equals("1")) {
				search.setSearchKeyword("%"+search.getSearchKeyword().toLowerCase()+"%");
			}
			if (search.getSearchCondition().equals("2")) {
				map.put("beginPrice", Integer.parseInt(search.getSearchKeyword().split(",")[0]));
				map.put("endPrice", Integer.parseInt(search.getSearchKeyword().split(",")[1]));
			}
		}
		if (search.getOrderCondition() != null && !search.getOrderCondition().equals(""))
			search.setOrderCondition(search.getOrderCondition());
		
		
		map.put("search", search);
		map.put("startRowNum", (search.getCurrentPage()-1) * search.getPageSize() + 1);
		map.put("endRowNum", search.getCurrentPage() * search.getPageSize());
		
		System.out.println("before");
		List<Product> list = sqlSession.selectList("ProductMapper.getProductList", map);
		System.out.println("after");
		
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getProTranCode() != null)
				list.get(i).setProTranCode(list.get(i).getProTranCode().trim());
		}
		System.out.println("finish");
		
		return list;
	}
	
	@Override
	public int getTotalCount(Search search) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("beginPrice", -1);
		map.put("endPrice", -1);
		if (search.getSearchKeyword() != null && !search.getSearchKeyword().equals("")) {
			if (search.getSearchCondition().equals("1")) {
				search.setSearchKeyword("%"+search.getSearchKeyword().toLowerCase()+"%");
			}
			if (search.getSearchCondition().equals("2")) {
				map.put("beginPrice", Integer.parseInt(search.getSearchKeyword().split(",")[0]));
				map.put("endPrice", Integer.parseInt(search.getSearchKeyword().split(",")[1]));
			}
		}
		map.put("search", search);
		
		return sqlSession.selectOne("ProductMapper.getTotalCount", map);
	}

	@Override
	public int addProdImage(ProdImage prodImage) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("ProductMapper.addProdImage", prodImage);
	}

	@Override
	public List<ProdImage> getProdImgList(int prodNo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("ProductMapper.getProdImgList", prodNo);
	}
	
	@Override
	public ProdImage getProdImage(int imgId) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("ProductMapper.getProdImage", imgId);
	}

	@Override
	public int removeProdImage(int imgId) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("ProductMapper.removeProdImage", imgId);
	}

	@Override
	public int getSeq_product_prod_no() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("ProductMapper.getSeq_product_prod_no");
	}
	
	public List<String> getProdNameList() throws Exception {
		return sqlSession.selectList("ProductMapper.getProdNameList");
	}

}
