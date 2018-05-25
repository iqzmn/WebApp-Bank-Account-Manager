package com.exchange.dao;

import com.exchange.model.UserAvatar;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("userAvatarDao")
public class UserAvatarDaoImpl extends AbstractDao<Integer, UserAvatar> implements UserAvatarDao{

    @Override
    public UserAvatar findById(int id) {
        return getByKey(id);
    }

    @Override
    public void save(UserAvatar avatar) {
        persist(avatar);
    }

    @SuppressWarnings("unchecked")
    public UserAvatar findByUserId(int userId) {
        Criteria crit = createEntityCriteria();
        Criteria userCriteria = crit.createCriteria("user");
        userCriteria.add(Restrictions.eq("id", userId));
        return (UserAvatar)crit.uniqueResult();
    }

    @Override
    public void deleteById(int id) {
        UserAvatar avatar =  getByKey(id);
        delete(avatar);
        avatar = null;
    }
}
