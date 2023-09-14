package com.model2.mvc.web.user;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;


//==> ȸ������ RestController
@RestController
@RequestMapping("/user/*")
public class UserRestController {
	
	///Field
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	//setter Method ���� ����
		
	public UserRestController(){
		System.out.println(this.getClass());
	}
	
//	@Value("#{commonProperties['pageUnit']}")
	@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
//	@Value("#{commonProperties['pageSize']}")
	@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	@RequestMapping( value="json/getUser/{userId}", method=RequestMethod.GET )
	public User getUser( @PathVariable String userId ) throws Exception{
		
		System.out.println("/user/json/getUser : GET");
		
		//Business Logic
		return userService.getUser(userId);
	}
	
	@RequestMapping(value="json/login", method=RequestMethod.GET)
	public String loginView() throws Exception{
		
		System.out.println("/user/json/login : GET");

		return "redirect:/user/loginView.jsp";
	}

	@RequestMapping( value="json/login", method=RequestMethod.POST )
	public User login(	@RequestBody User user,
									HttpSession session ) throws Exception{
	
		System.out.println("/user/json/login : POST");
		//Business Logic
		System.out.println("::"+user);
		User dbUser=userService.getUser(user.getUserId());
		
		if( user.getPassword().equals(dbUser.getPassword())){
			session.setAttribute("user", dbUser);
		}
		
		return dbUser;
	}
	
	@RequestMapping(value="json/logout", method=RequestMethod.GET )
	public String logout(HttpSession session ) throws Exception{
		
		System.out.println("/user/json/logout : GET");
		
		session.invalidate();
		
		return "redirect:/index.jsp";
	}
	
	@RequestMapping(value="json/checkDuplication", method=RequestMethod.POST)
	public Map checkDuplication( @RequestBody String userId ) throws Exception{
		
		System.out.println("/user/json/checkDuplication : POST");
		//Business Logic
		boolean result=userService.checkDuplication(userId);
		
		Map map = new HashMap();
		map.put("result", new Boolean(result));
		map.put("userId", userId);

		return map;
	}
	
	@RequestMapping(value="json/getUserAutocompleteList/{query}", method=RequestMethod.GET)
	public List<String> getUserAutocompleteList(@PathVariable String query) throws Exception{
		
		System.out.println("/user/json/getUserNameList : GET");
		
		List<String> list = new ArrayList<String>();
		
		if (query.equals("user_id")) {
			list = userService.getUserIdList();
		} else if (query.equals("user_name")) {
			list = userService.getUserNameList();
		}
		
		return list;
	}
}