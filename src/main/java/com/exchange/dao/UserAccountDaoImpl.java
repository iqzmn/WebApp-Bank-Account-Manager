package com.exchange.dao;

import com.exchange.model.UserAccount;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("userAccountDao")
public class UserAccountDaoImpl extends AbstractDao<Integer, UserAccount> implements UserAccountDao {


    @Override
    @SuppressWarnings("unchecked")
    public List<UserAccount> findAll() {
        Criteria crit = createEntityCriteria();
        return (List<UserAccount>)crit.list();
    }

    @Override
    public UserAccount findById(int id) {
        return getByKey(id);
    }

    @Override
    public void save(UserAccount account) {
        persist(account);
    }

    @Override
    public void upd(UserAccount account){
        update(account);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<UserAccount> findAllByUserId(int userId) {
        Criteria crit = createEntityCriteria();
        Criteria userCriteria = crit.createCriteria("user");
        userCriteria.add(Restrictions.eq("id", userId));
        return (List<UserAccount>)crit.list();
    }

    @Override
    public void deleteById(int id) {
        UserAccount account =  getByKey(id);
        delete(account);
    }
}
