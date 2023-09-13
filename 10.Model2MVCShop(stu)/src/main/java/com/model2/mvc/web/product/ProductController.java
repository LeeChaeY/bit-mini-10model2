package com.model2.mvc.web.product;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.ProdImage;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

import oracle.net.aso.f;


//==> ȸ������ Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method ���� ����
		
	public ProductController(){
		System.out.println(this.getClass());
	}
	
	//==> classpath:config/common.properties  ,  classpath:config/commonservice.xml ���� �Ұ�
	//==> �Ʒ��� �ΰ��� �ּ��� Ǯ�� �ǹ̸� Ȯ�� �Ұ�
//	@Value("#{commonProperties['pageUnit']}")
	@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
//	@Value("#{commonProperties['pageSize']}")
	@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	
	@RequestMapping(value="addProduct", method=RequestMethod.GET )
	public String addProduct() throws Exception {

		System.out.println("/product/addProduct : GET");
		
		return "redirect:/product/addProductView.jsp";
	}
	
	@RequestMapping(value="addProduct", method=RequestMethod.POST)
	public String addProduct( @RequestParam("file") List<MultipartFile> files, @ModelAttribute("product") Product product , Model model, 
						HttpServletRequest request) throws Exception {
			System.out.println("addProduct : POST : "+product);	
			List<ProdImage> imgList = new ArrayList<ProdImage>();
			
			String fileNames =  "";
			if (files.size() != 0) {
	            try {
	                // ���ε�� ���� ����
//	            	String uploadDir = "C:\\work\\03.git\\bit-mini-09model2\\09.Model2MVCShop(stu)\\src\\main\\\\webapp\\images\\uploadFiles\\";
	            	String uploadDir = "F:\\git\\bit-mini-10model2\\10.Model2MVCShop(stu)\\src\\main\\webapp\\images\\uploadFiles\\";
//	                String uploadDir = "\\images\\uploadFiles\\"; // ���� ��η� �����ؾ� �մϴ�.
	            	for (int i=0; i<files.size(); i++) {
		                File uploadFile = new File(uploadDir, files.get(i).getOriginalFilename());
		                files.get(i).transferTo(uploadFile);
		                
		                if (i == 0) product.setFileName(files.get(i).getOriginalFilename());
		                System.out.println("iiiiiiiiiiiiiiiiiiiiiii"+i);
		                
		                imgList.add(new ProdImage(product.getProdNo(), files.get(i).getOriginalFilename()));
		                
		                //fileNames += files.get(i).getOriginalFilename()+",";
	            	}
	            	//fileNames = fileNames.substring(0, fileNames.length()-1);
	            	//product.setFileName(fileNames);
	            	System.out.println("imgList"+imgList.size());
            		product.setImgList(imgList);
	            	
	            	// ���� ���ε� ���� �޽��� ���� ó���ϰų� �ٸ� �۾��� �����մϴ�.
	                product.setManuDate(product.getManuDate().replace("-", ""));
	                System.out.println("ssssssssssssss");
	                
	                int result = productService.addProduct(product);
	                System.out.println("FFFFFFFFF: "+result);
	    			model.addAttribute("product", product);
	    			System.out.println("ssssssssssssss");
	                
	            } catch (Exception e) {
	                e.printStackTrace();
	                // ���� ���ε� ���� ó��
	                System.out.println("<scrpt>alert('������ ũ��� 10MB���� �Դϴ�.");
	            }
	        } else {
	            // ���ε�� ������ ���� ��� ó��
	        	System.out.println("���ڵ� Ÿ���� multipart/form-data�� �ƴմϴ�..");
	        }	
			
		return "forward:/product/addProduct.jsp";
	}
	
	@RequestMapping(value="getProduct", method=RequestMethod.GET )
	public String getProduct(HttpServletRequest request, HttpServletResponse response,  
									@RequestParam("prodNo") int prodNo, @RequestParam("menu") String menu , Model model ) throws Exception {
		String resultPage = "forward:/product/getProduct.jsp";
		System.out.println("getProduct : GET : prodNo : "+prodNo+", menu : "+menu);
		//Business Logic
		Product product = productService.getProduct(prodNo);
		// Model �� View ����
		model.addAttribute("product", product);
		model.addAttribute("menu", menu);
		
		if (menu.equals("manage") && product.getProTranCode() == null) 
			resultPage = "redirect:/product/updateProduct?prodNo="+prodNo;

		Cookie[] cookies = request.getCookies();
		String history = null;
		if (cookies!=null && cookies.length > 0) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				if (cookie.getName().equals("history")) {
					history = cookie.getValue();
				}
			}
			if (history != null) {
				List<String> h = new ArrayList<String>(Arrays.asList(history.split(URLEncoder.encode(","))));
				if (h.indexOf(prodNo+"") != -1) h.remove(h.indexOf(prodNo+""));
				h.add(""+prodNo);
				history = String.join(URLEncoder.encode(","), h);
			}
			else {
				history = prodNo+"";
			}
		}
		
		System.out.println("getProduct :: cookie history : "+history);
		Cookie cookie = new Cookie("history", history);
		cookie.setMaxAge(60*60);
		response.addCookie(cookie);
		
		return resultPage;
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.GET )
	public String updateProduct( @RequestParam("prodNo") int prodNo , Model model ) throws Exception{

		System.out.println("updateProduct : GET : "+prodNo);
		//Business Logic
		Product product = productService.getProduct(prodNo);
		// Model �� View ����
		model.addAttribute("product", product);
		
		return "forward:/product/updateProductView.jsp";
	}
	
	@RequestMapping(value="updateProduct", method=RequestMethod.POST)
	public String updateProduct( @RequestParam("file") List<MultipartFile> files, @ModelAttribute("product") Product product, @RequestParam("deleteImg") String deleteImg) throws Exception{
		String menu = "search";
		
		System.out.println("updateProduct : POST : "+product);
		
		String deleteDir = "F:\\git\\bit-mini-10model2\\10.Model2MVCShop(stu)\\src\\main\\webapp\\images\\uploadFiles\\";
    	if (!deleteImg.equals("")) {
    		for (String imgId : deleteImg.substring(0, deleteImg.length()).split(",")) {
    			ProdImage img = productService.getProdImage(Integer.parseInt(imgId));
    			productService.removeProdImage(Integer.parseInt(imgId));
    			
    			deleteDir = deleteDir + File.separator + img.getFileName();
    			File fileToDelete = new File(deleteDir);
    			
    			// ������ �����մϴ�.
    	    	if (fileToDelete.exists()) {
    	    	    if (fileToDelete.delete()) {
    	    	        System.out.println("������ ���������� �����Ǿ����ϴ�.");
    	    	    } else {
    	    	        System.out.println("������ �����ϴ� �� ������ �߻��߽��ϴ�.");
    	    	    }
    	    	}
    		}
    		
    	}
		
		if (files.size() != 0) {
            try {
                // ���ε�� ���� ����
//            	String uploadDir = "C:\\work\\03.git\\bit-mini-09model2\\09.Model2MVCShop(stu)\\src\\main\\\\webapp\\images\\uploadFiles\\";
            	String uploadDir = "F:\\git\\bit-mini-10model2\\10.Model2MVCShop(stu)\\src\\main\\webapp\\images\\uploadFiles\\";
//             String uploadDir = "\\images\\uploadFiles\\"; // ���� ��η� �����ؾ� �մϴ�.
            	
            	List<ProdImage> imgList = new ArrayList<ProdImage>();
            	
            	for (int i=0; i<files.size(); i++) {
            		if (!files.get(i).getOriginalFilename().equals("")) {
	                File uploadFile = new File(uploadDir, files.get(i).getOriginalFilename());
	                files.get(i).transferTo(uploadFile);
	                
//	                if (i == 0) product.setFileName(files.get(i).getOriginalFilename());
	                
	                imgList.add(new ProdImage(product.getProdNo(), files.get(i).getOriginalFilename()));
            		}
	            }
            	
            	System.out.println("imgList.size() : "+imgList.size());
        		product.setImgList(imgList);
                // ���� ���ε� ���� �޽��� ���� ó���ϰų� �ٸ� �۾��� �����մϴ�.
                product.setManuDate(product.getManuDate().replace("-", ""));
                
                //	Business Logic
        		productService.updateProduct(product);
                
            } catch (IOException e) {
                e.printStackTrace();
                // ���� ���ε� ���� ó��
                System.out.println("<scrpt>alert('������ ũ��� 10MB���� �Դϴ�.");
            }
        } else {
            // ���ε�� ������ ���� ��� ó��
        	System.out.println("���ڵ� Ÿ���� multipart/form-data�� �ƴմϴ�..");
        }
		
		return "redirect:/product/getProduct?prodNo="+product.getProdNo()+"&menu="+menu;
	}
	
	@RequestMapping(value="listProduct")
	public String listProduct( @ModelAttribute("search") Search search, @RequestParam("menu") String menu , 
											Model model , HttpServletRequest request) throws Exception{
		String beginPrice = null;
		String endPrice = null;
		
		if(request.getParameter("beginPrice") != null && !request.getParameter("beginPrice").equals("") 
				&& request.getParameter("endPrice") != null &&!request.getParameter("endPrice").equals("")) {
			search.setSearchCondition("2");
			beginPrice = request.getParameter("beginPrice");
			model.addAttribute("beginPrice", beginPrice);
			endPrice = request.getParameter("endPrice");
			model.addAttribute("endPrice", endPrice);
		} else if (search.getSearchKeyword() != null && !search.getSearchKeyword().equals("")) {
			search.setSearchCondition("1");
		}
		System.out.println("listProduct : GET / POST : "+search);
		System.out.println("listProduct : beginPrice : "+beginPrice+", endPrice : "+endPrice);
		
		if(search.getCurrentPage() == 0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		String searchKeyword = null;
		if(search.getSearchKeyword() != null && !search.getSearchKeyword().equals(""))
			searchKeyword = search.getSearchKeyword();
		
		// Business logic ����
		Map<String , Object> map=productService.getProductList(search);
		
		if(search.getSearchKeyword() != null && !search.getSearchKeyword().equals(""))
			search.setSearchKeyword(searchKeyword);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println("listProduct ::"+resultPage);
		search.setSearchKeyword("");
		// Model �� View ����
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		model.addAttribute("menu", menu);
		
		System.out.println(map.get("list"));
		System.out.println(search);
		System.out.println(menu);
		
		return "forward:/product/listProduct.jsp";
	}
}