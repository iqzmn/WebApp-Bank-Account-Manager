package com.exchange.controller;

import com.exchange.model.*;
import com.exchange.security.MyUrlAuthenticationSuccessHandler;
import com.exchange.service.UserAccountService;
import com.exchange.service.UserAvatarService;
import com.exchange.service.UserProfileService;
import com.exchange.service.UserService;
import com.exchange.util.FileValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationTrustResolver;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

@Controller
@RequestMapping("/")
@SessionAttributes("roles")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    UserProfileService userProfileService;
    @Autowired
    UserService userService;
    @Autowired
    PersistentTokenBasedRememberMeServices persistentTokenBasedRememberMeServices;
    @Autowired
    AuthenticationTrustResolver authenticationTrustResolver;
    @Autowired
    UserAvatarService userAvatarService;
    @Autowired
    FileValidator fileValidator;
    @Autowired
    UserAccountService userAccountService;
    @Autowired
    MyUrlAuthenticationSuccessHandler successHandler;

    @InitBinder("fileBucket")
    protected void initBinder(WebDataBinder binder) {
        binder.setValidator(fileValidator);
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public ModelAndView enterPoint(ModelAndView model, User user) {

        logger.info("Inside login");

        model.setViewName("login");

        return model;
    }

    /**
     * This method will list all existing users.
     */
    @RequestMapping(value = {"/admin" }, method = RequestMethod.GET)
    public String adminArea(ModelMap model, HttpServletRequest request, User user) {

        List<User> users = userService.findAllUsers();

        Object checkUserDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        Principal principal = request.getUserPrincipal();

        String loggedInUserName = (principal.getName()).toUpperCase();

        user = userService.findBySSO(loggedInUserName);

        model.addAttribute("users", users);
        model.addAttribute("loggedinuser", getPrincipal());

        if (!(checkUserDetails instanceof UserDetails)) {
            model.addAttribute("success", user.getFirstName() + " "+ user.getLastName() + " registered successfully!");
        }
        return "admin";
    }

    @RequestMapping(value = "/userPage", method = RequestMethod.GET)
    public String userPage(ModelMap model, HttpServletRequest request){

        Object checkUserDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        Principal principal = request.getUserPrincipal();

        String loggedInUserName = (principal.getName()).toUpperCase();

        User user = userService.findBySSO(loggedInUserName);

        List<UserAccount>accounts = userAccountService.findAllByUserId(user.getId());

        UserAccount userAccount = new UserAccount();

        if (!(checkUserDetails instanceof UserDetails)) {
            model.addAttribute("success", user.getFirstName() + " "+ user.getLastName() + " registered successfully!");
        }
        model.addAttribute("user", user);
        model.addAttribute("allAccounts", accounts);
        model.addAttribute("sum", totalSum(user.getId()));
        model.addAttribute("userAccount", userAccount);

        return "userPage";
    }

    /**Total sum on all accounts of user*/
    private BigDecimal totalSum(int userId){

        BigDecimal sum = new BigDecimal(0);

        List<UserAccount>accounts = userAccountService.findAllByUserId(userId);

        for(UserAccount userAccount: accounts){
            sum = sum.add(userAccount.getAmount());
        }

        return sum;
    }

    /**Register from admin area*/
    @RequestMapping(value = "/saveUser", method = RequestMethod.POST)
    public String newUser(@Valid @ModelAttribute("user")User user){

        userService.saveUser(user);
        return "redirect:/admin";
    }


    /**
     * This method will be called on form submission, handling POST request for
     * saving user in database. It also validates the user input
     */
    @RequestMapping(value = { "/newuser" }, method = RequestMethod.POST)
    public void newUser(User user,
                        HttpServletRequest request,
                        HttpServletResponse response){

        userService.saveUser(user);

        List<GrantedAuthority> authorities = new ArrayList<>();

        for(UserProfile userProfile : user.getUserProfiles()){
            logger.info("UserProfile : {}", userProfile);
            authorities.add(new SimpleGrantedAuthority("ROLE_"+userProfile.getType()));
        }

        Authentication auth = new UsernamePasswordAuthenticationToken(user.getSsoId(), user.getPassword(), authorities);
        SecurityContextHolder.getContext().setAuthentication(auth);

        try {
            successHandler.onAuthenticationSuccess(request,response,auth);
        } catch (IOException | ServletException e) {
            e.printStackTrace();
        }
    }

    /*Ajax ssoId controller*/
    @RequestMapping(value = "/checkId", method = RequestMethod.GET )
    @ResponseBody
    public Response ssoIdCheck(@RequestParam String text) {

        Response response = new Response();
        User user = userService.findBySSO(text);

            if (user == null){
                response.setText(text);
            }

        return response;
    }

    /**
     * This method provide link to userProfile from UserPage.
     */
    @RequestMapping(value = { "/user-profile-{ssoId}" }, method = RequestMethod.GET)
    public String editUser(@PathVariable String ssoId, ModelMap model) {

        User user = userService.findBySSO(ssoId);

        UserAvatar avatar = userAvatarService.findByUserId(user.getId());

        if(user.getUserAvatar()!= null) {
            model.addAttribute("base64code", avatar.getContent());
        }
        model.addAttribute("avatar", avatar);
        model.addAttribute("user", user);
        model.addAttribute("fileBucket", new FileBucket());
        model.addAttribute("sum", totalSum(user.getId()));

        return "userProfile";
    }

    /**
     * This method provide update userProfile.
     */
    @RequestMapping(value = { "/user-edit-{ssoId}" }, method = RequestMethod.POST)
    public String userUpdate(@Valid @ModelAttribute("user") User user,
                             @ModelAttribute("fileBucket")FileBucket fileBucket,
                             ModelMap model) {

        userService.updateUser(user);

        model.addAttribute("user", user);
        model.addAttribute("fileBucket", new FileBucket());

        return "redirect:/user-profile-"+ user.getSsoId();
    }


    /**
     * This method will be called on form submission, handling POST request for
     * updating user in database.
     */
    @RequestMapping(value = { "/edit-user-{ssoId}" }, method = RequestMethod.POST)
    public String updateUser(@Valid @ModelAttribute("user")User user) {
        userService.updateUser(user);

        return "redirect:/admin";
    }

    /**
     * This method will delete user by it's SSOID value.
     */
    @RequestMapping(value = { "/delete-admin-{ssoId}" }, method = RequestMethod.GET)
    public String deleteUser(@PathVariable String ssoId) {

        userService.deleteUserBySSO(ssoId);

        if(ssoId.equals(getPrincipal())){
            SecurityContextHolder.getContext().setAuthentication(null);
            return "accessDenied";
        }else

        return "redirect:/admin";
    }

    @RequestMapping(value = { "/user-delete-{ssoId}" }, method = RequestMethod.GET)
    public String userDelete(@PathVariable String ssoId) {
        userService.deleteUserBySSO(ssoId);

        return "redirect:/logout";
    }

    /**
     * This method will provide UserProfile list to views
     */
    @ModelAttribute("roles")
    public List<UserProfile> initializeProfiles() {
        return userProfileService.findAll();
    }

    /**
     * This method handles Access-Denied redirect.
     */
    @RequestMapping(value = "/Access_Denied", method = RequestMethod.GET)
    public String accessDeniedPage(ModelMap model) {
        model.addAttribute("loggedinuser", getPrincipal());

        return "accessDenied";
    }

    /**
     * This method handles logout requests.
     * Toggle the handlers if you are RememberMe functionality is useless in your app.
     */
    @RequestMapping(value="/logout", method = RequestMethod.GET)
    public String logoutPage (HttpServletRequest request, HttpServletResponse response){

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null){
            persistentTokenBasedRememberMeServices.logout(request, response, auth);
            SecurityContextHolder.getContext().setAuthentication(null);
        }
        return "redirect:/?logout";
    }

    /**
     * This method returns the principal[user-name] of logged-in user.
     */
    private String getPrincipal(){

        String userName = null;

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof UserDetails) {
            userName = ((UserDetails)principal).getUsername();
        } else {
            userName = principal.toString();
        }
        return userName;
    }

    /**
     * This method returns true if users is already authenticated [logged-in], else false.
     */
    private boolean isCurrentAuthenticationAnonymous() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authenticationTrustResolver.isAnonymous(authentication);
    }

    /**
     * This method provide update avatar on userProfile.
     */
    @RequestMapping(value = { "/add-avatar-{userId}" }, method = RequestMethod.POST)
    public String uploadAvatar( @Valid @ModelAttribute("fileBucket")FileBucket fileBucket,
                                BindingResult result,
                                @PathVariable int userId,
                                ModelMap model) throws IOException{

        User user = userService.findById(userId);

        if (result.hasErrors()) {

            System.out.println("validation errors");

            UserAvatar avatar = userAvatarService.findByUserId(userId);

            model.addAttribute("user", user);
            model.addAttribute("avatar", avatar);
            model.addAttribute("sum", totalSum(user.getId()));

            return "userProfile";
        } else {

            if(user.getUserAvatar() != null){
                deleteAvatar(userId);
            }

            saveAvatar(fileBucket, user);

            model.addAttribute("user", user);
            model.addAttribute("fileBucket", new FileBucket());

            return "redirect:/user-profile-"+ user.getSsoId();
        }
    }

    private void saveAvatar(FileBucket fileBucket, User user) throws IOException{

        UserAvatar avatar = new UserAvatar();

        MultipartFile multipartFile = fileBucket.getFile();

        byte[] ava = multipartFile.getBytes();

        String encodedAvaString = Base64.getEncoder().encodeToString(ava);

        avatar.setName(multipartFile.getOriginalFilename());
        avatar.setType(multipartFile.getContentType());
        avatar.setContent(encodedAvaString);
        avatar.setUser(user);

        userAvatarService.saveAvatar(avatar);
    }

    @RequestMapping(value = { "/delete-avatar-{userId}" }, method = RequestMethod.GET)
    public String deleteAvatar(@PathVariable int userId) {

        User user = userService.findById(userId);

        userAvatarService.deleteById(user.getUserAvatar().getId());

        return "redirect:/user-profile-"+ user.getSsoId();
    }

    @RequestMapping(value = {"/deposit-{userId}"}, method = RequestMethod.POST)
    public String depositAccount(@PathVariable int userId,
                                 @ModelAttribute("userAccount")UserAccount userAccount,
                                 ModelMap model){

        User user = userService.findById(userId);

        userAccount.setAccountNumber(accountGenerator());
        userAccount.setUser(user);

        userAccountService.saveAccount(userAccount);

        model.addAttribute("user", user);

        return "redirect:/userPage";
    }

    @RequestMapping(value = {"/delete-{accountId}"}, method = RequestMethod.GET)
    public String deleteAccount(@PathVariable int accountId){
        userAccountService.deleteById(accountId);

        return "redirect:/userPage";
    }

    @RequestMapping(value = {"/refill-{userId}-{accountId}"}, method = RequestMethod.POST)
    public String refillAccount(@PathVariable int accountId,
                                @PathVariable int userId,
                                @ModelAttribute("userAccount")UserAccount userAccount){

        UserAccount account = userAccountService.findById(accountId);

        BigDecimal decimal = account.getAmount().add(userAccount.getAmount());

        account.setAmount(decimal);

        userAccountService.updateAccount(account);

        return "redirect:/accountManager-"+ userId + "-" + accountId + "?success";
    }

    @RequestMapping(value = {"/withdraw-{userId}-{accountId}"}, method = RequestMethod.POST)
    public String withdraw(@PathVariable int accountId,
                           @PathVariable int userId,
                           @ModelAttribute("userAccount")UserAccount userAccount){

        UserAccount account = userAccountService.findById(accountId);

        BigDecimal decimal = account.getAmount().subtract(userAccount.getAmount());

        account.setAmount(decimal);

        userAccountService.updateAccount(account);

        return "redirect:/accountManager-"+ userId + "-" + accountId + "?success";
    }

    @RequestMapping(value = {"/transfer-{userId}-{accountId}"}, method = RequestMethod.POST)
    public String transfer(@PathVariable int accountId,
                           @PathVariable int userId,
                           @ModelAttribute("userAccount")UserAccount userAccount){

        UserAccount outaccount = userAccountService.findById(accountId);

        BigDecimal amount = userAccount.getAmount();

       for(UserAccount account: userAccountService.findAll()){
          if(account.getAccountNumber().equals(userAccount.getAccountNumber())){

            account.setAmount(account.getAmount().add(amount));
            outaccount.setAmount(outaccount.getAmount().subtract(amount));

            userAccountService.updateAccount(account);
            userAccountService.updateAccount(outaccount);

          }
       }
        return "redirect:/accountManager-"+ userId + "-" + accountId + "?success";
    }

    /**This method redirect to manager of user account*/
    @RequestMapping(value = {"/accountManager-{userId}-{accountId}"}, method = RequestMethod.GET)
    public String accountManager(ModelMap model,
                                 @PathVariable int userId,
                                 @PathVariable int accountId ){

        User user = userService.findById(userId);
        UserAccount userAccount = new UserAccount();
        UserAccount account = userAccountService.findById(accountId);
        List<UserAccount> accounts = new ArrayList<>();

        for(UserAccount acc: userAccountService.findAll()){
            if(acc.getId() != accountId)
                accounts.add(acc);
        }

        model.addAttribute("user", user);
        model.addAttribute("userAccount", userAccount);
        model.addAttribute("account", account);
        model.addAttribute("accounts", accounts);
        model.addAttribute("sum",totalSum(user.getId()));

        return "accountManager";
    }


    private int accountGenerator(){
        return (int)(100000000 * Math.random());
    }
}
